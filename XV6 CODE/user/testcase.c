#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define PAGE_SIZE 4096
#define NUM_PAGES 64   // > MAX_FRAMES (32) → guarantees eviction

int
main(void)
{
  printf("=== testcase: basic swap write check ===\n");

  struct vmstats before, after;
  getvmstats(getpid(), &before);

  // Allocate enough pages to force eviction
  char *base = sbrk(NUM_PAGES * PAGE_SIZE);
  if(base == (char*)-1){
    printf("FAIL: sbrk failed\n");
    exit(1);
  }

  // Write to each page (forces them to be populated)
  for(int i = 0; i < NUM_PAGES; i++){
    base[i * PAGE_SIZE] = (char)i;
  }

  // Extra pressure to force eviction
  char *p = sbrk(80 * PAGE_SIZE);
  if(p != (char*)-1){
    for(int i = 0; i < 80; i++){
      p[i * PAGE_SIZE] = (char)i;
    }
    sbrk(-(80 * PAGE_SIZE));
  }

  getvmstats(getpid(), &after);

  uint64 writes = after.disk_writes - before.disk_writes;
  uint64 reads  = after.disk_reads  - before.disk_reads;

  printf("writes delta = %lu\n", writes);
  printf("reads  delta = %lu\n", reads);

  if(writes > 0)
    printf("PASS: eviction caused disk writes\n");
  else
    printf("FAIL: NO disk writes (swap_write not triggered)\n");

  if(reads > 0)
    printf("PASS: swap-in caused disk reads\n");
  else
    printf("NOTE: reads may be zero if pages not re-accessed\n");

  sbrk(-(NUM_PAGES * PAGE_SIZE));

  printf("=== testcase done ===\n");
  exit(0);
}