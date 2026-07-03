#include "kernel/types.h"
#include "user/user.h"

int main(void){
  int pid = fork();

  if(pid == 0){
    
    getpid();
    getpid();
    write(1, "c\n", 2);
    exit(0);   
  }
  
 pause(100);

  
  int cnt = getchildsyscount(pid);

  printf("child syscall count = %d\n", cnt);

  wait(0);   

  
  int cnt2 = getchildsyscount(pid);
  printf("after wait = %d\n", cnt2);

  exit(0);
}

