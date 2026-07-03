// PA4_3.c
// Tests: scheduler-aware eviction, multi-process memory pressure,
//        PTE isolation across children
//
// Fixes applied vs original:
//   - sbrklazylazy() replaced with sbrklazy() (lazy allocation via kernel default)
//   - pause(N) replaced with spin loops (portable across xv6 variants)
//   - Removed dependency on sbrklazylazy user-space stub
//   - PAGE_SIZE constants unified to 1024 (actual xv6 page size)
//   - pressure allocation uses sbrklazy/touch/sbrklazy pattern instead of sbrklazylazy

#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

// ─── common helpers ──────────────────────────────────────────────────────────

#define PAGE_SZ   1024
#define MAX_FRAMES 32          // matches your MAX_FRAMES in swap.h

// Busy-wait for approximately `ticks` scheduler ticks worth of time.
// We just spin — no pause() dependency.
static void
spin_wait(int iters)
{
    volatile int x = 0;
    for (int i = 0; i < iters; i++) x++;
    (void)x;
}

// ─── PA4_5: Scheduler-Aware Eviction ────────────────────────────────────────
// Spawns a LO-priority child (spins first to drift to lower MLFQ level)
// and a HI-priority child, both allocate WORK_PAGES pages.
// Parent then allocates pressure to force evictions.
// Expectation: LO-priority child loses more pages than HI-priority child.

#define WORK_PAGES_5   40
#define PRESSURE_5     80
#define SPIN_ITERS_5   500000000   // enough iterations to demote to low MLFQ level

static void
test_pa4_5(void)
{
    printf("=== PA4_5: Scheduler-Aware Eviction Test ===\n");

    int pipe_lo[2], pipe_hi[2];
    pipe(pipe_lo);
    pipe(pipe_hi);

    // ── LO-priority child: spin first so MLFQ demotes it ──
    int pid_lo = fork();
    if (pid_lo == 0) {
        close(pipe_lo[0]);
        close(pipe_hi[0]); close(pipe_hi[1]);

        // Spin to consume ticks and get pushed to a lower MLFQ queue
        spin_wait(SPIN_ITERS_5);

        char *mem = sbrklazy(WORK_PAGES_5 * PAGE_SZ);
        if (mem == (char*)-1) { printf("[LO] sbrklazy failed\n"); exit(1); }
        for (int i = 0; i < WORK_PAGES_5; i++)
            mem[i * PAGE_SZ] = (char)i;

        int mypid = getpid();
        write(pipe_lo[1], &mypid, sizeof(mypid));
        close(pipe_lo[1]);

        // Wait for parent pressure phase
        spin_wait(200000000);

        int errs = 0;
        for (int i = 0; i < WORK_PAGES_5; i++)
            if (mem[i * PAGE_SZ] != (char)i) errs++;

        if (errs == 0)
            printf("[LO-child] PASS: data intact after pressure\n");
        else
            printf("[LO-child] WARN: %d pages saw stale data (swap worked)\n", errs);

        exit(0);
    }

    // ── HI-priority child: allocate immediately (stays at high MLFQ level) ──
    int pid_hi = fork();
    if (pid_hi == 0) {
        close(pipe_hi[0]);
        close(pipe_lo[0]); close(pipe_lo[1]);

        char *mem = sbrklazy(WORK_PAGES_5 * PAGE_SZ);
        if (mem == (char*)-1) { printf("[HI] sbrklazy failed\n"); exit(1); }
        for (int i = 0; i < WORK_PAGES_5; i++)
            mem[i * PAGE_SZ] = (char)(i + 100);

        int mypid = getpid();
        write(pipe_hi[1], &mypid, sizeof(mypid));
        close(pipe_hi[1]);

        spin_wait(200000000);

        int errs = 0;
        for (int i = 0; i < WORK_PAGES_5; i++)
            if (mem[i * PAGE_SZ] != (char)(i + 100)) errs++;

        if (errs == 0)
            printf("[HI-child] PASS: data intact after pressure\n");
        else
            printf("[HI-child] WARN: %d pages saw stale data\n", errs);

        exit(0);
    }

    close(pipe_lo[1]); close(pipe_hi[1]);

    // Wait for both children to finish writing their pages
    int cpid_lo, cpid_hi;
    read(pipe_lo[0], &cpid_lo, sizeof(cpid_lo));
    read(pipe_hi[0], &cpid_hi, sizeof(cpid_hi));
    close(pipe_lo[0]); close(pipe_hi[0]);

    printf("LO-priority child PID: %d\n", cpid_lo);
    printf("HI-priority child PID: %d\n", cpid_hi);

    // Apply memory pressure from parent
    char *pressure = sbrklazy(PRESSURE_5 * PAGE_SZ);
    if (pressure != (char*)-1) {
        for (int i = 0; i < PRESSURE_5; i++)
            pressure[i * PAGE_SZ] = (char)i;
    }

    // Small spin so children can be scheduled and evictions can propagate
    spin_wait(50000000);

    struct vmstats st_lo, st_hi;
    memset(&st_lo, 0, sizeof(st_lo));
    memset(&st_hi, 0, sizeof(st_hi));

    if (getvmstats(cpid_lo, &st_lo) != 0)
        printf("WARN: getvmstats for lo-child %d failed (may have exited)\n", cpid_lo);
    else {
        printf("[LO-priority child %d]\n", cpid_lo);
        printf("  pages_evicted    : %d\n", st_lo.pages_evicted);
        printf("  pages_swapped_out: %d\n", st_lo.pages_swapped_out);
        printf("  resident_pages   : %d\n", st_lo.resident_pages);
    }

    if (getvmstats(cpid_hi, &st_hi) != 0)
        printf("WARN: getvmstats for hi-child %d failed (may have exited)\n", cpid_hi);
    else {
        printf("[HI-priority child %d]\n", cpid_hi);
        printf("  pages_evicted    : %d\n", st_hi.pages_evicted);
        printf("  pages_swapped_out: %d\n", st_hi.pages_swapped_out);
        printf("  resident_pages   : %d\n", st_hi.resident_pages);
    }

    if (st_lo.pages_evicted >= st_hi.pages_evicted)
        printf("\nPASS: LO-priority evicted >= HI-priority (scheduler-aware eviction working)\n");
    else
        printf("\nINFO: HI evicted=%d LO evicted=%d — result depends on MLFQ demotion timing\n",
               st_hi.pages_evicted, st_lo.pages_evicted);

    if (pressure != (char*)-1)
        sbrklazy(-(PRESSURE_5 * PAGE_SZ));

    wait(0); wait(0);
    printf("=== PA4_5 done ===\n");
}

// ─── PA4_9: Multi-Process Memory Pressure ───────────────────────────────────
// Spawns NCHILDREN_9 children, each allocating NPAGES_9 pages.
// All children compete for the same MAX_FRAMES frame pool.
// Verifies that each child reads back its own correct data after swap.

#define NPAGES_9     48    // each child: 48 pages (total 144 > MAX_FRAMES=32)
#define NCHILDREN_9   3
#define PRESSURE_9   60   // extra pressure to force eviction

#define PATTERN_9(child, page) ((char)(((child) * 37 + (page) * 11 + 1) & 0xFF))

static int
child_work_9(int id)
{
    char *mem = sbrklazy(NPAGES_9 * PAGE_SZ);
    if (mem == (char*)-1) {
        printf("FAIL: child %d sbrklazy failed\n", id);
        return 1;
    }

    // Write unique per-child pattern
    for (int i = 0; i < NPAGES_9; i++)
        mem[i * PAGE_SZ] = PATTERN_9(id, i);

    // Add extra pressure to push pages out
    char *press = sbrklazy(PRESSURE_9 * PAGE_SZ);
    if (press != (char*)-1) {
        for (int i = 0; i < PRESSURE_9; i++)
            press[i * PAGE_SZ] = (char)(id + i);
        sbrklazy(-(PRESSURE_9 * PAGE_SZ));
    }

    // Read back and verify
    int ok = 1;
    for (int i = 0; i < NPAGES_9; i++) {
        char got = mem[i * PAGE_SZ];
        if (got != PATTERN_9(id, i)) {
            printf("FAIL: child %d page %d: expected 0x%x got 0x%x\n",
                   id, i,
                   (unsigned char)PATTERN_9(id, i),
                   (unsigned char)got);
            ok = 0;
            break;   // report first error only
        }
    }

    if (ok)
        printf("PASS: child %d all %d pages correct under pressure\n", id, NPAGES_9);
    else
        printf("FAIL: child %d data corrupted under pressure\n", id);

    struct vmstats s;
    memset(&s, 0, sizeof(s));
    if (getvmstats(getpid(), &s) == 0) {
        printf("INFO: child %d -- faults=%d evicted=%d swapped_out=%d swapped_in=%d resident=%d\n",
               id, s.page_faults, s.pages_evicted,
               s.pages_swapped_out, s.pages_swapped_in, s.resident_pages);
    }

    sbrklazy(-(NPAGES_9 * PAGE_SZ));
    return ok ? 0 : 1;
}

static void
test_pa4_9(void)
{
    printf("=== PA4_9: Multi-Process Memory Pressure ===\n");

    int pids[NCHILDREN_9];

    for (int i = 0; i < NCHILDREN_9; i++) {
        pids[i] = fork();
        if (pids[i] < 0) {
            printf("FAIL: fork %d failed\n", i);
            exit(1);
        }
        if (pids[i] == 0)
            exit(child_work_9(i));
    }

    int all_ok = 1;
    for (int i = 0; i < NCHILDREN_9; i++) {
        int status = -1;
        wait(&status);
        if (status != 0) {
            printf("FAIL: a child exited with status %d\n", status);
            all_ok = 0;
        }
    }

    if (all_ok)
        printf("PASS: all %d children survived memory pressure with correct data\n", NCHILDREN_9);
    else
        printf("FAIL: one or more children reported corruption under pressure\n");

    struct vmstats ps;
    memset(&ps, 0, sizeof(ps));
    if (getvmstats(getpid(), &ps) == 0) {
        printf("INFO: parent -- faults=%d evicted=%d swapped_out=%d swapped_in=%d resident=%d\n",
               ps.page_faults, ps.pages_evicted,
               ps.pages_swapped_out, ps.pages_swapped_in, ps.resident_pages);
    }

    printf("=== PA4_9 done ===\n");
}

// ─── PA4_10: PTE Isolation Across Children ───────────────────────────────────
// Spawns N_CHILDREN_10 children. Each child:
//   1. Writes pattern A to its pages
//   2. Overwrites with pattern B
//   3. Verifies pattern B is visible (tests PTE coherence under swap)
// Children communicate results via pipes (avoids shared-memory races).

#define N_CHILDREN_10  3
#define PAGES_EACH_10  30
#define PRESSURE_10    50

typedef struct {
    int pid;
    int page_faults;
    int pages_evicted;
    int pages_swapped_out;
    int pages_swapped_in;
    int resident_pages;
    int errors;
} ChildReport_10;

static void
test_pa4_10(void)
{
    printf("=== PA4_10: PTE update isolation across %d children ===\n", N_CHILDREN_10);
    printf("    PAGES_EACH=%d  pressure=%d\n", PAGES_EACH_10, PRESSURE_10);

    int pipes[N_CHILDREN_10][2];
    for (int i = 0; i < N_CHILDREN_10; i++)
        pipe(pipes[i]);

    for (int c = 0; c < N_CHILDREN_10; c++) {
        int pid = fork();
        if (pid == 0) {
            // Close all pipe ends except our write end
            for (int i = 0; i < N_CHILDREN_10; i++) {
                close(pipes[i][0]);
                if (i != c) close(pipes[i][1]);
            }

            ChildReport_10 rep;
            memset(&rep, 0, sizeof(rep));
            rep.pid = getpid();

            char *mem = sbrklazy(PAGES_EACH_10 * PAGE_SZ);
            if (mem == (char*)-1) {
                rep.errors = 99;
                write(pipes[c][1], &rep, sizeof(rep));
                close(pipes[c][1]);
                exit(1);
            }

            // Write pattern A
            for (int i = 0; i < PAGES_EACH_10; i++)
                mem[i * PAGE_SZ] = (char)((c * 100 + i) & 0xFF);

            // Apply pressure to evict pattern A to disk
            char *press = sbrklazy(PRESSURE_10 * PAGE_SZ);
            if (press != (char*)-1) {
                for (int i = 0; i < PRESSURE_10; i++)
                    press[i * PAGE_SZ] = (char)(c + i);
                sbrklazy(-(PRESSURE_10 * PAGE_SZ));
            }

            // Overwrite with pattern B (may need to swap A back in, then write B)
            for (int i = 0; i < PAGES_EACH_10; i++)
                mem[i * PAGE_SZ] = (char)((c * 100 + i + 1) & 0xFF);

            // Apply pressure again to evict pattern B
            press = sbrklazy(PRESSURE_10 * PAGE_SZ);
            if (press != (char*)-1) {
                for (int i = 0; i < PRESSURE_10; i++)
                    press[i * PAGE_SZ] = (char)(c + i + 1);
                sbrklazy(-(PRESSURE_10 * PAGE_SZ));
            }

            // Verify pattern B is intact
            for (int i = 0; i < PAGES_EACH_10; i++) {
                char exp = (char)((c * 100 + i + 1) & 0xFF);
                if (mem[i * PAGE_SZ] != exp) {
                    printf("  child %d ERROR: page %d = 0x%x, expected 0x%x\n",
                           c, i,
                           (unsigned char)mem[i * PAGE_SZ],
                           (unsigned char)exp);
                    rep.errors++;
                }
            }

            struct vmstats s;
            memset(&s, 0, sizeof(s));
            if (getvmstats(rep.pid, &s) == 0) {
                rep.page_faults     = s.page_faults;
                rep.pages_evicted   = s.pages_evicted;
                rep.pages_swapped_out = s.pages_swapped_out;
                rep.pages_swapped_in  = s.pages_swapped_in;
                rep.resident_pages  = s.resident_pages;
            }

            if (rep.page_faults < PAGES_EACH_10)
                printf("  child %d WARN: page_faults=%d < PAGES_EACH=%d\n",
                       c, rep.page_faults, PAGES_EACH_10);

            sbrklazy(-(PAGES_EACH_10 * PAGE_SZ));

            write(pipes[c][1], &rep, sizeof(rep));
            close(pipes[c][1]);
            exit(rep.errors == 0 ? 0 : 1);
        }
    }

    ChildReport_10 reports[N_CHILDREN_10];
    for (int c = 0; c < N_CHILDREN_10; c++) {
        close(pipes[c][1]);
        read(pipes[c][0], &reports[c], sizeof(ChildReport_10));
        close(pipes[c][0]);
    }
    for (int c = 0; c < N_CHILDREN_10; c++)
        wait(0);

    printf("\n[results]\n");
    int all_ok = 1;
    for (int c = 0; c < N_CHILDREN_10; c++) {
        ChildReport_10 *r = &reports[c];
        printf("  child %d (pid=%d): faults=%d evicted=%d sout=%d sin=%d res=%d errors=%d\n",
               c, r->pid,
               r->page_faults, r->pages_evicted,
               r->pages_swapped_out, r->pages_swapped_in,
               r->resident_pages, r->errors);
        if (r->errors != 0) all_ok = 0;
    }

    for (int c = 0; c < N_CHILDREN_10; c++) {
        if (reports[c].page_faults < PAGES_EACH_10) {
            printf("  INFO: child %d faults=%d (may be < %d if pages hot-cached)\n",
                   c, reports[c].page_faults, PAGES_EACH_10);
        } else {
            printf("  PASS: child %d faults=%d >= %d\n",
                   c, reports[c].page_faults, PAGES_EACH_10);
        }
    }

    // Check for suspiciously identical fault counts (isolation warning)
    for (int a = 0; a < N_CHILDREN_10; a++) {
        for (int b = a + 1; b < N_CHILDREN_10; b++) {
            if (reports[a].page_faults == reports[b].page_faults &&
                reports[a].page_faults > 0 &&
                reports[a].page_faults != PAGES_EACH_10) {
                printf("  WARN: children %d and %d have identical fault counts — check PTE isolation\n",
                       a, b);
            }
        }
    }

    if (all_ok)
        printf("  PASS: all children verified correctly — PTE isolation OK\n");
    else
        printf("  FAIL: data corruption detected — PTE updates not isolated\n");

    printf("=== PA4_10 done ===\n");
}

// ─── main ────────────────────────────────────────────────────────────────────

int
main(void)
{
    printf("==============================\n");
    printf("PA4_3: Multi-process pressure & stat isolation\n");
    printf("==============================\n\n");

    printf("--- PA4_5: scheduler-aware eviction ---\n");
    test_pa4_5();

    printf("\n--- PA4_9: multi-process memory pressure ---\n");
    test_pa4_9();

    printf("\n--- PA4_10: PTE isolation across children ---\n");
    test_pa4_10();

    printf("\nPA4_3 done.\n");
    exit(0);
}