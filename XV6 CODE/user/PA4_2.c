// Merged: PA4_3 + PA4_4 + PA4_6 + PA4_8
// Tests: Clock reference bit, page replacement, swap correctness stress, replacement with sentinels

#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define PAGE_SIZE_3    4096
#define FRAME_LIMIT_3  32
#define HOT_PAGES    10
#define COLD_PAGES   15
#define PRESSURE_PAGES (FRAME_LIMIT_3 * 2)

static void
test_pa4_3(void)
{
    struct vmstats st;
    int pid = getpid();

    printf("=== test_clock: Clock Reference Bit Behavior ===\n");

    char *hot  = sbrklazy((uint64)HOT_PAGES * PAGE_SIZE_3);
    char *cold = sbrklazy((uint64)COLD_PAGES * PAGE_SIZE_3);

    if (hot == (char *)-1 || cold == (char *)-1) {
        printf("FAIL: sbrk\n");
        return;
    }

    for (int i = 0; i < HOT_PAGES; i++)
        hot[i * PAGE_SIZE_3] = (char)(0xAA);

    for (int i = 0; i < COLD_PAGES; i++)
        cold[i * PAGE_SIZE_3] = (char)(0xBB);

    for (int round = 0; round < 5; round++) {
        for (int i = 0; i < HOT_PAGES; i++)
            hot[i * PAGE_SIZE_3] = (char)(0xAA + round);
    }

    char *pressure = sbrklazy((uint64)PRESSURE_PAGES * PAGE_SIZE_3);
    if (pressure == (char *)-1) {
        printf("FAIL: sbrk for pressure\n");
        return;
    }
    for (int i = 0; i < PRESSURE_PAGES; i++)
        pressure[i * PAGE_SIZE_3] = (char)i;

    printf("[Verifying HOT pages]\n");
    int hot_errs = 0;
    char expected_hot = (char)(0xAA + 4);
    for (int i = 0; i < HOT_PAGES; i++) {
        if (hot[i * PAGE_SIZE_3] != expected_hot) {
            printf("  FAIL: hot page %d corrupted (got 0x%x expected 0x%x)\n",
                   i,
                   (unsigned char)hot[i * PAGE_SIZE_3],
                   (unsigned char)expected_hot);
            hot_errs++;
        }
    }
    if (hot_errs == 0)
        printf("  PASS: all %d hot pages intact\n", HOT_PAGES);
    else
        printf("  FAIL: %d hot pages corrupted — Clock may not be protecting recently used pages\n",
               hot_errs);

    getvmstats(pid, &st);
    printf("\n--- VM Stats ---\n");
    printf("  page_faults      : %d\n", st.page_faults);
    printf("  pages_evicted    : %d\n", st.pages_evicted);
    printf("  pages_swapped_out: %d\n", st.pages_swapped_out);
    printf("  pages_swapped_in : %d\n", st.pages_swapped_in);
    printf("  resident_pages   : %d\n", st.resident_pages);

    if (st.pages_evicted > 0)
        printf("PASS: evictions occurred — Clock algorithm is running\n");
    else
        printf("WARN: no evictions — increase PRESSURE_PAGES or lower FRAME_LIMIT\n");

    printf("=== test_clock done ===\n");
}

#define PAGE_SIZE_4   64
#define FRAME_LIMIT_4 64
#define NUM_PAGES_4   (FRAME_LIMIT_4 * 3)

static void
test_pa4_4(void)
{
    struct vmstats before, after;
    int pid = getpid();

    printf("=== test_replacement: Clock Page Replacement Test ===\n");
    printf("PID: %d | Frame limit: %d | Allocating: %d pages\n",
           pid, FRAME_LIMIT_4, NUM_PAGES_4);

    char *mem = sbrklazy((uint64)NUM_PAGES_4 * PAGE_SIZE_4);
    if (mem == (char *)-1) {
        printf("FAIL: sbrk failed\n");
        return;
    }

    getvmstats(pid, &before);

    printf("[Phase 1] Writing %d pages sequentially...\n", NUM_PAGES_4);
    for (int i = 0; i < NUM_PAGES_4; i++) {
        mem[i * PAGE_SIZE_4] = (char)(i & 0xFF);
    }

    getvmstats(pid, &after);
    printf("  page_faults      : %d\n", after.page_faults - before.page_faults);
    printf("  pages_evicted    : %d\n", after.pages_evicted - before.pages_evicted);
    printf("  pages_swapped_out: %d\n", after.pages_swapped_out - before.pages_swapped_out);
    printf("  resident_pages   : %d\n", after.resident_pages);

    if (after.pages_evicted > 0)
        printf("PASS: evictions occurred (%d)\n", after.pages_evicted);
    else
        printf("WARN: no evictions yet — increase NUM_PAGES or lower FRAME_LIMIT\n");

    printf("[Phase 2] Reading back all %d pages...\n", NUM_PAGES_4);
    int errs = 0;
    for (int i = 0; i < NUM_PAGES_4; i++) {
        char expected = (char)(i & 0xFF);
        if (mem[i * PAGE_SIZE_4] != expected) {
            printf("FAIL: page %d: expected %d got %d\n",
                   i, (int)(unsigned char)expected,
                   (int)(unsigned char)mem[i * PAGE_SIZE_4]);
            errs++;
            if (errs > 5) { printf("  (too many errors, stopping)\n"); break; }
        }
    }
    if (errs == 0)
        printf("PASS: all %d pages read back correctly after eviction/swap-in\n",
               NUM_PAGES_4);

    getvmstats(pid, &after);
    printf("[Phase 2 stats]\n");
    printf("  pages_swapped_in : %d\n", after.pages_swapped_in);
    printf("  resident_pages   : %d\n", after.resident_pages);

    if (after.pages_swapped_in > 0)
        printf("PASS: swap-ins occurred (%d)\n", after.pages_swapped_in);
    else
        printf("WARN: no swap-ins recorded\n");

    printf("=== test_replacement done ===\n");
}

#define PAGE_SIZE_6   64
#define FRAME_LIMIT_6 32
#define NUM_PAGES_6   (FRAME_LIMIT_6 * 4)
#define NUM_PASSES_6  3

static inline char pattern_6(int page, int pass) {
    return (char)((page * 7 + pass * 13) & 0xFF);
}

static void
test_pa4_6(void)
{
    struct vmstats st;
    int pid = getpid();

    printf("=== test_swap: Swap Correctness Stress Test ===\n");
    printf("PID: %d | %d pages | %d passes\n", pid, NUM_PAGES_6, NUM_PASSES_6);

    char *mem = sbrklazy((uint64)NUM_PAGES_6 * PAGE_SIZE_6);
    if (mem == (char *)-1) {
        printf("FAIL: sbrk\n");
        return;
    }

    int total_errs = 0;

    for (int pass = 0; pass < NUM_PASSES_6; pass++) {
        printf("\n--- Pass %d: writing patterns ---\n", pass);

        for (int i = 0; i < NUM_PAGES_6; i++)
            mem[i * PAGE_SIZE_6] = pattern_6(i, pass);

        printf("--- Pass %d: reading back ---\n", pass);
        int errs = 0;
        for (int i = 0; i < NUM_PAGES_6; i++) {
            char expected = pattern_6(i, pass);
            char got = mem[i * PAGE_SIZE_6];
            if (got != expected) {
                printf("  ERR page %d: expected 0x%x got 0x%x\n",
                       i, (unsigned char)expected, (unsigned char)got);
                errs++;
                if (errs > 10) { printf("  (stopping early)\n"); break; }
            }
        }
        total_errs += errs;

        getvmstats(pid, &st);
        printf("  page_faults      : %d\n", st.page_faults);
        printf("  pages_evicted    : %d\n", st.pages_evicted);
        printf("  pages_swapped_out: %d\n", st.pages_swapped_out);
        printf("  pages_swapped_in : %d\n", st.pages_swapped_in);
        printf("  resident_pages   : %d\n", st.resident_pages);

        if (errs == 0)
            printf("PASS: pass %d data integrity OK\n", pass);
        else
            printf("FAIL: pass %d had %d data errors\n", pass, errs);
    }

    printf("\n=== Summary ===\n");
    if (total_errs == 0)
        printf("PASS: all passes completed with correct data\n");
    else
        printf("FAIL: total data errors across all passes: %d\n", total_errs);

    getvmstats(pid, &st);
    if (st.pages_swapped_in > 0)
        printf("PASS: pages_swapped_in = %d (swap-in works)\n", st.pages_swapped_in);
    else
        printf("FAIL: pages_swapped_in == 0 — swap-in not being tracked\n");

    if (st.pages_swapped_out > 0)
        printf("PASS: pages_swapped_out = %d (swap-out works)\n", st.pages_swapped_out);
    else
        printf("FAIL: pages_swapped_out == 0\n");

    printf("=== test_swap done ===\n");
}

#define PAGE_SIZE_8   1024
#define MAXFRAMES_8   64
#define EXTRA_8       8
#define TOTAL_PAGES_8 (MAXFRAMES_8 + EXTRA_8)

static void dump_8(const char *tag, struct vmstats *s) {
    printf("[repl] %s faults=%d evicted=%d sout=%d sin=%d resident=%d\n",
           tag,
           s->page_faults, s->pages_evicted,
           s->pages_swapped_out, s->pages_swapped_in,
           s->resident_pages);
}

static void
test_pa4_8(void)
{
    printf("=== Test 3: Page replacement (MAXFRAMES=%d, TOTAL=%d) ===\n",
           MAXFRAMES_8, TOTAL_PAGES_8);

    int pid = getpid();
    struct vmstats s0, s1;

    char *mem = sbrklazy(TOTAL_PAGES_8 * PAGE_SIZE_8);
    if (mem == (char *)-1) { printf("FAIL: sbrk\n"); return; }

    getvmstats(pid, &s0);

    printf("Writing %d pages...\n", TOTAL_PAGES_8);
    for (int i = 0; i < TOTAL_PAGES_8; i++) {
        mem[i * PAGE_SIZE_8] = (char)(i + 1);
    }

    getvmstats(pid, &s1);
    dump_8("after writing all pages", &s1);

    int evictions = s1.pages_evicted - s0.pages_evicted;
    if (evictions >= EXTRA_8)
        printf("  PASS: at least %d evictions occurred (%d)\n", EXTRA_8, evictions);
    else
        printf("  FAIL: expected >= %d evictions, got %d\n", EXTRA_8, evictions);

    if (s1.pages_swapped_out >= evictions)
        printf("  PASS: pages_swapped_out=%d >= evictions=%d\n",
               s1.pages_swapped_out, evictions);
    else
        printf("  WARN: swapped_out=%d < evictions=%d\n",
               s1.pages_swapped_out, evictions);

    printf("Re-reading all %d pages (checking sentinels)...\n", TOTAL_PAGES_8);
    int swap_in_before = s1.pages_swapped_in;
    int errors = 0;

    for (int i = 0; i < TOTAL_PAGES_8; i++) {
        char expected = (char)(i + 1);
        char got = mem[i * PAGE_SIZE_8];
        if (got != expected) {
            printf("  FAIL: page %d: expected %d got %d\n", i, (int)expected, (int)got);
            errors++;
        }
    }

    getvmstats(pid, &s1);
    dump_8("after re-reading all pages", &s1);

    int swap_ins = s1.pages_swapped_in - swap_in_before;
    if (swap_ins > 0)
        printf("  PASS: %d swap-ins occurred during re-read\n", swap_ins);
    else
        printf("  WARN: 0 swap-ins – either pages still resident or stat not updated\n");

    if (errors == 0)
        printf("  PASS: all %d page sentinels intact (data survives eviction)\n", TOTAL_PAGES_8);
    else
        printf("  FAIL: %d data corruption(s) detected\n", errors);

    if (s1.resident_pages <= MAXFRAMES_8)
        printf("  PASS: resident_pages=%d <= MAXFRAMES=%d\n",
               s1.resident_pages, MAXFRAMES_8);
    else
        printf("  FAIL: resident_pages=%d > MAXFRAMES=%d (over-committed)\n",
               s1.resident_pages, MAXFRAMES_8);

    printf("=== Test 3 done (errors=%d) ===\n", errors);
}

int
main(void)
{
  printf("==============================\n");
  printf("PA4_B: Clock eviction & swap correctness\n");
  printf("==============================\n\n");

  printf("--- PA4_3: clock reference bit ---\n");
  test_pa4_3();

  printf("\n--- PA4_4: clock page replacement ---\n");
  test_pa4_4();

  printf("\n--- PA4_6: swap correctness stress ---\n");
  test_pa4_6();

  printf("\n--- PA4_8: page replacement sentinels ---\n");
  test_pa4_8();

  printf("\nPA4_B done.\n");
  exit(0);
}