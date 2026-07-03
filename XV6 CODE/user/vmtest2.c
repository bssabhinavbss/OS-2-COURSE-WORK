#include "kernel/types.h"
#include "user/user.h"

int main() {
  printf("TEST2: Eviction\n");

  char *p = sbrklazy(40 * 4096);

  for(int i = 0; i < 40; i++)
    p[i*4096] = i;

  struct vmstats s;
  getvmstats(getpid(), &s);

  printf("faults=%d evicted=%d swapped_out=%d resident=%d\n",
    s.page_faults, s.pages_evicted,
    s.pages_swapped_out, s.resident_pages);

  exit(0);
}
