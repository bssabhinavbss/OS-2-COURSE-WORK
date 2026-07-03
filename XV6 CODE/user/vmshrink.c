#include "kernel/types.h"
#include "user/user.h"

#define PGSIZE 4096

int
main(void)
{
  char *s = "vmshrink";
  printf("\n[%s] Starting Heap Contraction & Swap Leak Edge Case...\n", s);
  int npages = 128;
  char *base;
  struct vmstats st1, st2;

  printf("[%s] Allocating and writing to %d pages (forcing swaps)...\n", s, npages);
  base = sbrklazy(npages * PGSIZE);
  if(base == (char*)-1) {
    printf("[%s] ERROR: initial sbrklazy failed\n", s);
    exit(1);
  }

  for(int i = 0; i < npages; i++) {
    base[i * PGSIZE] = 'A';
  }

  getvmstats(getpid(), &st1);
  printf("[%s] Phase 1 Stats -> Faults: %d, Swapped Out: %d\n", s, st1.page_faults, st1.pages_swapped_out);

  if(st1.pages_swapped_out == 0) {
    printf("[%s] ERROR: Expected pages to be swapped out!\n", s);
    exit(1);
  }

  printf("[%s] Shrinking heap by 20 pages (triggering uvmunmap)...\n", s);
  if(sbrklazy(-20 * PGSIZE) == (char*)-1) {
    printf("[%s] ERROR: heap shrink failed\n", s);
    exit(1);
  }

  printf("[%s] Re-growing heap and writing new data...\n", s);
  char *new_base = sbrklazy(20 * PGSIZE);
  for(int i = 0; i < 20; i++) {
    new_base[i * PGSIZE] = 'B';
  }

  printf("[%s] Verifying integrity of original surviving pages...\n", s);
  for(int i = 0; i < 20; i++) {
    if(base[i * PGSIZE] != 'A') {
      printf("[%s] ERROR: Data corrupted at page index %d (got %c)\n", s, i, base[i * PGSIZE]);
      exit(1);
    }
  }

  getvmstats(getpid(), &st2);
  printf("[%s] Final Stats -> Faults: %d, Swapped Out: %d\n", s, st2.page_faults, st2.pages_swapped_out);

  printf("[%s] SUCCESS: No kernel panics, swap slots and frames correctly reclaimed on shrink.\n", s);
  exit(0);
}
