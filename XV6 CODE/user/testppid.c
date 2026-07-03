#include "kernel/types.h"
#include "user/user.h"

int main(void){
  printf("my pid = %d\n", getpid());
  printf("parent pid = %d\n", getppid());
  exit(0);
}
