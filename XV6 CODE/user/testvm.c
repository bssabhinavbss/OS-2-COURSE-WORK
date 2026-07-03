#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define PGSIZE 4096
#define MAX_FRAMES 32

void print_stats(char *msg) {
  struct vmstats s;
  if(getvmstats(getpid(), &s) < 0){
    printf("getvmstats failed\n");
    return;
  }
  printf("%s\n", msg);
  printf("faults=%d evicted=%d in=%d out=%d resident=%d\n",
    s.page_faults,
    s.pages_evicted,
    s.pages_swapped_in,
    s.pages_swapped_out,
    s.resident_pages);
}

//////////////////////////////////////////////////////
// TEST 1: BASIC (fault + eviction + swap)
//////////////////////////////////////////////////////
void vmbasic() {
  printf("\n=== Test 1: Basic VM ===\n");

  int npages = 50;
  char *base = sbrklazy(npages * PGSIZE);

  struct vmstats st1, st2, st3;

  getvmstats(getpid(), &st1);

  for(int i = 0; i < npages; i++)
    base[i * PGSIZE] = i;

  getvmstats(getpid(), &st2);

  if(st2.page_faults <= st1.page_faults)
    printf("FAIL: faults not increasing\n");

  if(st2.pages_evicted == 0)
    printf("FAIL: no eviction\n");

  if(st2.pages_swapped_out == 0)
    printf("FAIL: no swap-out\n");

  for(int i = 0; i < npages; i++){
    if(base[i * PGSIZE] != i){
      printf("FAIL: data mismatch at %d\n", i);
      exit(1);
    }
  }

  getvmstats(getpid(), &st3);

  if(st3.pages_swapped_in == 0)
    printf("FAIL: no swap-in\n");

  printf("PASS\n");
}

//////////////////////////////////////////////////////
// TEST 2: FORK + VM
//////////////////////////////////////////////////////
void vmfork() {
  printf("\n=== Test 2: Fork ===\n");

  int npages = 40;
  char *base = sbrklazy(npages * PGSIZE);

  for(int i = 0; i < npages; i++)
    base[i * PGSIZE] = i + 10;

  int pid = fork();

  if(pid == 0){
    for(int i = 0; i < npages; i++){
      if(base[i * PGSIZE] != i + 10){
        printf("Child mismatch\n");
        exit(1);
      }
    }
    printf("Child OK\n");
    exit(0);
  }

  wait(0);
  printf("Parent OK\n");
}

//////////////////////////////////////////////////////
// TEST 3: SWAP-IN
//////////////////////////////////////////////////////
void test_swapin() {
  printf("\n=== Test 3: Swap-in ===\n");

  char *p = sbrklazy(50 * PGSIZE);

  for(int i = 0; i < 50; i++)
    p[i * PGSIZE] = i;

  int ok = 1;
  for(int i = 0; i < 50; i++){
    if(p[i * PGSIZE] != i){
      ok = 0;
      break;
    }
  }

  printf("Data integrity: %s\n", ok ? "PASS" : "FAIL");

  print_stats("After swap-in");
}

//////////////////////////////////////////////////////
// TEST 4: SHRINK + REUSE
//////////////////////////////////////////////////////
void test_shrink() {
  printf("\n=== Test 4: Shrink ===\n");

  struct vmstats st1, st2;

  getvmstats(getpid(), &st1);

  char *p = sbrklazy(20 * PGSIZE);

  for(int i = 0; i < 20; i++)
    p[i * PGSIZE] = i;

  sbrklazy(-20 * PGSIZE);

  getvmstats(getpid(), &st2);

  if(st2.resident_pages != st1.resident_pages)
    printf("FAIL: memory leak\n");
  else
    printf("PASS: freed correctly\n");

  char *p2 = sbrklazy(20 * PGSIZE);
  for(int i = 0; i < 20; i++)
    p2[i * PGSIZE] = i;

  printf("Reuse successful\n");
}

//////////////////////////////////////////////////////
// TEST 5: THRASHING
//////////////////////////////////////////////////////
void test_thrashing() {
  printf("\n=== Test 5: Thrashing ===\n");

  int pages = 33;
  char *p = sbrklazy(pages * PGSIZE);

  for(int i = 0; i < pages; i++)
    p[i * PGSIZE] = 1;

  for(int k = 0; k < 5; k++){
    for(int i = 0; i < pages; i++)
      p[i * PGSIZE]++;
  }

  print_stats("After thrashing");
}

//////////////////////////////////////////////////////
// TEST 6: EXEC CLEANUP
//////////////////////////////////////////////////////
void test_exec_cleanup() {
  printf("\n=== Test 6: Exec cleanup ===\n");

  int pid = fork();

  if(pid == 0){
    char *p = sbrklazy(42 * PGSIZE);
    for(int i = 0; i < 42; i++)
      p[i * PGSIZE] = 'z';

    char *args[] = {"echo", "Exec test", 0};
    exec("echo", args);
    exit(1);
  }

  wait(0);
  printf("Exec cleanup OK\n");
}

//////////////////////////////////////////////////////
// TEST 7: EDGE SWAP-IN TRIGGER
//////////////////////////////////////////////////////
void edge_recursive_swap() {
  printf("\n=== Test 7: Recursive swap ===\n");

  char *p = sbrklazy(40 * PGSIZE);

  for(int i = 0; i < 40; i++)
    p[i * PGSIZE] = i;

  char val = p[0];

  printf("Value=%d (should be 0)\n", val);
}

//////////////////////////////////////////////////////
// MAIN
//////////////////////////////////////////////////////
int main() {
  printf("\n===== VM TEST SUITE =====\n");

  if(fork() == 0){ vmbasic(); exit(0); } wait(0);
  if(fork() == 0){ vmfork(); exit(0); } wait(0);
  if(fork() == 0){ test_swapin(); exit(0); } wait(0);
  if(fork() == 0){ test_shrink(); exit(0); } wait(0);
  if(fork() == 0){ test_thrashing(); exit(0); } wait(0);
  if(fork() == 0){ test_exec_cleanup(); exit(0); } wait(0);
  if(fork() == 0){ edge_recursive_swap(); exit(0); } wait(0);

  printf("\n===== ALL TESTS DONE =====\n");
  exit(0);
}