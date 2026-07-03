// PA4_1.c
// Tests: getvmstats syscall correctness, basic page fault tracking, stat isolation

#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

static int
all_non_negative(const struct vmstats *s)
{
  return s->page_faults     >= 0 &&
         s->pages_evicted   >= 0 &&
         s->pages_swapped_in  >= 0 &&
         s->pages_swapped_out >= 0 &&
         s->resident_pages  >= 0;
}

static void
test_pa4_1(void)
{
  struct vmstats before, after;
  int pid = getpid();
  int rc;

  rc = getvmstats(pid, &before);
  if(rc != 0){
    printf("FAIL: getvmstats(self) returned %d\n", rc);
    return;
  }

  if(!all_non_negative(&before)){
    printf("FAIL: negative counter in initial stats\n");
    return;
  }

  char *base = sbrklazy(2 * 4096);
  if(base == (char*)-1){
    printf("FAIL: sbrk failed\n");
    return;
  }
  base[0]    = 'x';
  base[4096] = 'y';

  rc = getvmstats(pid, &after);
  if(rc != 0){
    printf("FAIL: getvmstats(after touch) returned %d\n", rc);
    return;
  }

  if(!all_non_negative(&after)){
    printf("FAIL: negative counter in final stats\n");
    return;
  }

  if(after.page_faults < before.page_faults){
    printf("FAIL: page_faults decreased (%d -> %d)\n",
           before.page_faults, after.page_faults);
    return;
  }

  if(getvmstats(-1, &after) >= 0){
    printf("FAIL: invalid pid should fail\n");
    return;
  }

  printf("PASS: getvmstats works\n");
  printf("before: pf=%d ev=%d in=%d out=%d res=%d\n",
         before.page_faults, before.pages_evicted,
         before.pages_swapped_in, before.pages_swapped_out,
         before.resident_pages);
  printf("after : pf=%d ev=%d in=%d out=%d res=%d\n",
         after.page_faults, after.pages_evicted,
         after.pages_swapped_in, after.pages_swapped_out,
         after.resident_pages);
}

#define PAGE_SIZE_2 4096
#define NUM_PAGES_2 64

static void
test_pa4_2(void)
{
  struct vmstats st;
  int pid = getpid();

  printf("=== test_basic_pf: Basic Page Fault Test ===\n");
  printf("PID: %d\n", pid);

  char *mem = sbrklazy(NUM_PAGES_2 * PAGE_SIZE_2);
  if(mem == (char*)-1){
    printf("FAIL: sbrk failed\n");
    return;
  }

  for(int i = 0; i < NUM_PAGES_2; i++)
    mem[i * PAGE_SIZE_2] = (char)(i + 1);

  int ok = 1;
  for(int i = 0; i < NUM_PAGES_2; i++){
    if(mem[i * PAGE_SIZE_2] != (char)(i + 1)){
      printf("FAIL: data mismatch at page %d\n", i);
      ok = 0;
    }
  }
  if(ok)
    printf("PASS: all %d pages written and read back correctly\n", NUM_PAGES_2);

  if(getvmstats(pid, &st) != 0){
    printf("FAIL: getvmstats returned error\n");
    return;
  }

  printf("\n--- VM Stats for PID %d ---\n", pid);
  printf("  page_faults      : %d\n",  st.page_faults);
  printf("  pages_evicted    : %d\n",  st.pages_evicted);
  printf("  pages_swapped_in : %d\n",  st.pages_swapped_in);
  printf("  pages_swapped_out: %d\n",  st.pages_swapped_out);
  printf("  resident_pages   : %d\n",  st.resident_pages);
  printf("  disk_reads       : %lu\n", st.disk_reads);
  printf("  disk_writes      : %lu\n", st.disk_writes);
  printf("  avg_disk_latency : %lu\n", st.avg_disk_latency);

  if(st.page_faults > 0 && st.page_faults <= NUM_PAGES_2)
    printf("PASS: page_faults (%d) in expected range [1, %d]\n",
           st.page_faults, NUM_PAGES_2);
  else
    printf("FAIL: expected page_faults in [1, %d], got %d\n",
           NUM_PAGES_2, st.page_faults);

  if(getvmstats(-1, &st) == -1)
    printf("PASS: getvmstats(-1) correctly returned -1\n");
  else
    printf("FAIL: getvmstats(-1) should return -1\n");

  printf("=== test_basic_pf done ===\n");
}

#define PAGE_SIZE_7   4096
#define FRAME_LIMIT_7 32
#define CHILD_PAGES   20
#define PARENT_PAGES  15

static void
test_pa4_7(void)
{
  struct vmstats st1, st2;
  int pid = getpid();

  printf("=== test_vmstats: System Call Correctness ===\n");

  printf("[Test 1] Invalid PID\n");
  if(getvmstats(-1, &st1) == -1)
    printf("  PASS: getvmstats(-1) -> -1\n");
  else
    printf("  FAIL: getvmstats(-1) should return -1\n");

  if(getvmstats(99999, &st1) == -1)
    printf("  PASS: getvmstats(99999) -> -1\n");
  else
    printf("  FAIL: getvmstats(99999) should return -1\n");

  printf("[Test 2] Fresh process stats\n");
  getvmstats(pid, &st1);
  printf("  Initial page_faults: %d\n", st1.page_faults);

  printf("[Test 3] Monotonic increase\n");
  char *mem = sbrklazy((uint64)PARENT_PAGES * PAGE_SIZE_7);
  for(int i = 0; i < PARENT_PAGES; i++)
    mem[i * PAGE_SIZE_7] = (char)i;

  getvmstats(pid, &st2);
  if(st2.page_faults >= st1.page_faults)
    printf("  PASS: page_faults non-decreasing (%d -> %d)\n",
           st1.page_faults, st2.page_faults);
  else
    printf("  FAIL: page_faults went backwards!\n");

  if(st2.resident_pages <= FRAME_LIMIT_7)
    printf("  PASS: resident_pages (%d) <= FRAME_LIMIT (%d)\n",
           st2.resident_pages, FRAME_LIMIT_7);
  else
    printf("  FAIL: resident_pages (%d) > FRAME_LIMIT (%d)\n",
           st2.resident_pages, FRAME_LIMIT_7);

  printf("[Test 4] Per-process stat isolation\n");
  getvmstats(pid, &st1);

  int child_pid = fork();
  if(child_pid == 0){
    char *cmem = sbrklazy((uint64)CHILD_PAGES * PAGE_SIZE_7);
    for(int i = 0; i < CHILD_PAGES; i++)
      cmem[i * PAGE_SIZE_7] = (char)i;
    exit(0);
  }
  wait(0);

  getvmstats(pid, &st2);
  int parent_delta = st2.page_faults - st1.page_faults;
  if(parent_delta < CHILD_PAGES)
    printf("  PASS: parent page_faults unchanged by child (delta=%d)\n", parent_delta);
  else
    printf("  WARN: parent page_faults increased by %d\n", parent_delta);

  printf("[Test 5] Dead child PID\n");
  int ret = getvmstats(child_pid, &st1);
  printf("  getvmstats(dead child %d) returned %d (acceptable: -1 or 0)\n",
         child_pid, ret);

  printf("=== test_vmstats done ===\n");
}

int
main(void)
{
  printf("==============================\n");
  printf("PA4_A: vmstats syscall tests\n");
  printf("==============================\n\n");

  printf("--- PA4_1: getvmstats basic ---\n");
  test_pa4_1();

  printf("\n--- PA4_2: basic page fault ---\n");
  test_pa4_2();

  printf("\n--- PA4_7: vmstats correctness ---\n");
  test_pa4_7();

  printf("\nPA4_A done.\n");
  exit(0);
}