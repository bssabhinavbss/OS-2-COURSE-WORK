#include "kernel/types.h"
#include "user/user.h"

int main() {
  printf("TEST3: Swap-in\n");

  char *p = sbrklazy(40 * 4096);

  for(int i = 0; i < 40; i++)
    p[i*4096] = i;

  // second pass
  for(int i = 0; i < 40; i++){
    if(p[i*4096] != i){
      printf("ERROR at %d\n", i);
      exit(1);
    }
  }

  struct vmstats s;
  getvmstats(getpid(), &s);

  printf("swapped_in=%d\n", s.pages_swapped_in);

  exit(0);
}
