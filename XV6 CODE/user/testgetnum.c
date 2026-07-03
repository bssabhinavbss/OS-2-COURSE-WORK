#include "kernel/types.h"
#include "user/user.h"

int main(void){
  int before = getnumchild();
  printf("children before fork = %d\n", before);
  int pid = fork();
  if (pid == 0){
    pause(100);
    exit(0);
  }
  pause(10); 
  int after = getnumchild();
  printf("children after fork = %d\n", after);
  wait(0);
  int final = getnumchild();
  printf("children after wait = %d\n", final);
  exit(0);
}
