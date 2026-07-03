#include "kernel/types.h"
#include "user/user.h"

int main(void){
  int p1 = getpid();
  int p2 = getpid2();
  printf("The value of getpid  = %d\n", p1);
  printf("The value of getpid2 = %d\n", p2);
  exit(0);
}
