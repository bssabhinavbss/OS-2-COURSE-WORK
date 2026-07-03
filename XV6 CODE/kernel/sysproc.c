#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"
#include "vm.h"
#include "disksched.h"

extern struct proc proc[NPROC];
extern struct spinlock wait_lock;
uint64
sys_exit(void)
{
  int n;
  argint(0, &n);
  kexit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return kfork();
}

uint64
sys_wait(void)
{
  uint64 p;
  argaddr(0, &p);
  return kwait(p);
}

uint64
sys_sbrk(void)
{
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
  argint(1, &t);
  addr = myproc()->sz;

  if(t == SBRK_EAGER || n < 0) {
    if(growproc(n) < 0) {
      return -1;
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if(addr + n < addr)
      return -1;
    if(addr + n > TRAPFRAME)
      return -1;
    myproc()->sz += n;
  }
  return addr;
}

uint64
sys_pause(void)
{
  int n;
  uint ticks0;

  argint(0, &n);
  if(n < 0)
    n = 0;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

uint64
sys_kill(void)
{
  int pid;

  argint(0, &pid);
  return kkill(pid);
}

uint64
sys_hello(void) // hello 
{
  printf("Hello from the kernel!\n");
  return 0;
}

uint64
sys_getpid2(void){
  struct proc *p = myproc();
  return p->pid;
}

uint64
sys_getppid(void){
  struct proc *p = myproc();
  int ppid = -1;
  acquire(&wait_lock);
  if (p->parent != 0){
    ppid = p->parent->pid;
  }
  release(&wait_lock);

  return ppid;
}

uint64
sys_getnumchild(void){
  struct proc *p = myproc();
  struct proc *traverse = proc;
  int count = 0;
  acquire(&wait_lock);
  while(traverse < &proc[NPROC]){
    if(traverse->parent==p && traverse->state!=ZOMBIE){
      count++;
    }
    traverse++;
  }
  release(&wait_lock);
  return count;
}

uint64
sys_getsyscount(void)
{
  struct proc *p = myproc();
  return p->syscount;
}

uint64
sys_getchildsyscount(void){
  int pid;
  struct proc *p = myproc();
  struct proc *traversal=proc;
  
  argint(0, &pid);
  acquire(&wait_lock);
  while(traversal<&proc[NPROC]){
    if(traversal->pid== pid && traversal->parent==p){
      uint64 count = traversal->syscount;
      release(&wait_lock);
      return count;
    }
    traversal++;
  }
  release(&wait_lock);

  return -1;


}

uint64
sys_getlevel(void)
{
    return myproc()->level;
}
// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

uint64
sys_getmlfqinfo(void)
{
    int pid;
    uint64 addr;
    struct proc *p;

    argint(0, &pid);
    argaddr(1, &addr);

    for(p = proc; p < &proc[NPROC]; p++){
        acquire(&p->lock);
        if(p->pid == pid){

            struct mlfqinfo info;
            info.level = p->level;
            info.times_scheduled = p->times_scheduled;
            info.total_syscalls = p->syscount;

            for(int i = 0; i < 4; i++){
                info.ticks[i] = p->total_ticks[i];
            }
            release(&p->lock);

            if(copyout(myproc()->pagetable, addr,(char *)&info,sizeof(info)) < 0){
                return -1;
            }
            return 0;
        }
        release(&p->lock);
    }

    return -1;
}

uint64
sys_getvmstats(void)
{
  int pid;
  uint64 addr;

  argint(0, &pid);
  argaddr(1, &addr);

  struct vmstats s;

  if(getvmstats(pid, &s) < 0)
    return -1;

  if(copyout(myproc()->pagetable, addr, (char *)&s, sizeof(s)) < 0)
    return -1;

  return 0;
}
uint64
sys_setdisksched(void)
{
  int policy;
  argint(0, &policy);
  if(policy != DISK_SCHED_FCFS && policy != DISK_SCHED_SSTF)
    return -1;
  disksched_set_policy(policy);
  return 0;
}