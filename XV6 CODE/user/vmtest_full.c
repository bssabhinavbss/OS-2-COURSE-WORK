#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define PGSIZE 4096
#define MAX_FRAMES 32

void
print_stats(int pid)
{
  struct vmstats s;
  if(getvmstats(pid, &s) < 0){
    printf("  getvmstats failed for pid=%d\n", pid);
    return;
  }
  printf("  faults=%d evicted=%d swapped_in=%d swapped_out=%d resident=%d\n",
    s.page_faults, s.pages_evicted,
    s.pages_swapped_in, s.pages_swapped_out,
    s.resident_pages);
}

// Test 1: trigger page faults only — stays within MAX_FRAMES
void
test_pagefaults(void)
{
  printf("Test 1: page faults (10 pages, no eviction expected)\n");
  int pid = getpid();
  char *p = sbrklazy(10 * PGSIZE);
  for(int i = 0; i < 10; i++)
    p[i * PGSIZE] = 'A' + i;
  print_stats(pid);
}

// Test 2: force eviction — allocate well beyond MAX_FRAMES
void
test_eviction(void)
{
  printf("Test 2: eviction (50 pages > MAX_FRAMES=%d)\n", MAX_FRAMES);
  int pid = getpid();
  char *p = sbrklazy(50 * PGSIZE);
  for(int i = 0; i < 50; i++)
    p[i * PGSIZE] = (char)i;
  print_stats(pid);
}

// Test 3: verify swap-in — re-access previously evicted pages
void
test_swapin(void)
{
  printf("Test 3: swap-in + data integrity\n");
  int pid = getpid();
  char *p = sbrklazy(50 * PGSIZE);

  for(int i = 0; i < 50; i++)
    p[i * PGSIZE] = (char)i;

  int ok = 1;
  for(int i = 0; i < 50; i++){
    if(p[i * PGSIZE] != (char)i){
      printf("  FAIL at page %d: got %d expected %d\n",
             i, (int)p[i * PGSIZE], i);
      ok = 0;
      break;
    }
  }
  printf("  data integrity: %s\n", ok ? "PASS" : "FAIL");
  print_stats(pid);
}

// Test 4: priority effect
void
test_priority(void)
{
  printf("Test 4: priority effect\n");
  int pid = fork();
  if(pid == 0){
    // child: burn syscalls to drop MLFQ level
    for(int i = 0; i < 500; i++) getpid();
    char *p = sbrklazy(60 * PGSIZE);
    for(int i = 0; i < 60; i++)
      p[i * PGSIZE] = (char)i;
    printf("  child stats (more evictions expected):\n");
    print_stats(getpid());
    exit(0);
  } else {
    char *p = sbrklazy(15 * PGSIZE);
    for(int i = 0; i < 15; i++)
      p[i * PGSIZE] = (char)i;

    printf("  parent stats (fewer evictions expected):\n");
    print_stats(getpid());

    wait(0);
  }
}

int
main(void)
{
  printf("=== PA3 VM Tests ===\n");
  printf("MAX_FRAMES = %d\n\n", MAX_FRAMES);

  int pid;

  pid = fork();
  if(pid == 0){ test_pagefaults(); exit(0); }
  wait(0);
  printf("\n");

  pid = fork();
  if(pid == 0){ test_eviction(); exit(0); }
  wait(0);
  printf("\n");

  pid = fork();
  if(pid == 0){ test_swapin(); exit(0); }
  wait(0);
  printf("\n");

  test_priority();
  printf("\n");

  printf("=== Done ===\n");
  exit(0);
}
