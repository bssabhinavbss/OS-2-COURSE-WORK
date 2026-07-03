#include "kernel/types.h"
#include "user/user.h"

int main(void){
  int before, after;
  before = getsyscount();
  getpid();
  getpid();
  write(1, "x\n", 2);
  after = getsyscount();
  printf("syscalls before = %d\n", before);
  printf("syscalls after  = %d\n", after);
  int difference = after-before;
  printf("difference = %d\n", difference);

  exit(0);
}
