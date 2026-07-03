#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"

int mlfq_global_ticks = 0; 

struct spinlock tickslock;
uint ticks;

extern char trampoline[], uservec[];

// in kernelvec.S, calls kerneltrap().
void kernelvec();

extern int devintr();

void
trapinit(void)
{
  initlock(&tickslock, "time");
}

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
  w_stvec((uint64)kernelvec);
}

//
// handle an interrupt, exception, or system call from user space.
//
uint64
usertrap(void)
{
  int which_dev = 0;

  if((r_sstatus() & SSTATUS_SPP) != 0)
    panic("usertrap: not from user mode");

  // send traps to kerneltrap
  w_stvec((uint64)kernelvec);

  struct proc *p = myproc();

  // save user pc
  p->trapframe->epc = r_sepc();

  // =========================
  // SYSTEM CALL
  // =========================
  if(r_scause() == 8){
    if(killed(p))
      kexit(-1);

    p->trapframe->epc += 4;
    intr_on();
    syscall();

  // =========================
  // DEVICE INTERRUPT
  // =========================
  } else if((which_dev = devintr()) != 0){
    // handled

  // =========================
  // PAGE FAULT (FIXED)
  // =========================
  } else if(r_scause() == 12 || r_scause() == 13 || r_scause() == 15){
    uint64 va = r_stval();

    if(vmfault(p->pagetable, va, (r_scause()==15)) == 0){
      p->killed = 1;
    }

  // =========================
  // UNKNOWN TRAP
  // =========================
  } else {
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    setkilled(p);
  }

  // kill if needed
  if(killed(p))
    kexit(-1);

  // =========================
  // TIMER INTERRUPT (MLFQ)
  // =========================
  if(which_dev == 2){
    mlfq_global_ticks++;

    if(p && p->state == RUNNING){
       p->used_ticks++;
       p->total_ticks[p->level]++;
       yield();
    }

    // priority boost every 128 ticks
    if(mlfq_global_ticks % 128 == 0){
      struct proc *traverse; 
      for(traverse = proc; traverse < &proc[NPROC]; traverse++){
        acquire(&traverse->lock);
        if(traverse->state == RUNNABLE){
          traverse->level = 0;
        }
        release(&traverse->lock);
      }
    }
  }

  prepare_return();

  return MAKE_SATP(p->pagetable);
}

//
// prepare to return to user
//
void
prepare_return(void)
{
  struct proc *p = myproc();

  intr_off();

  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
  w_stvec(trampoline_uservec);

  p->trapframe->kernel_satp = r_satp();
  p->trapframe->kernel_sp = p->kstack + PGSIZE;
  p->trapframe->kernel_trap = (uint64)usertrap;
  p->trapframe->kernel_hartid = r_tp();

  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP;
  x |= SSTATUS_SPIE;
  w_sstatus(x);

  w_sepc(p->trapframe->epc);
}

//
// kernel trap handler
//
void 
kerneltrap()
{
  int which_dev = 0;
  uint64 sepc = r_sepc();
  uint64 sstatus = r_sstatus();
  uint64 scause = r_scause();
  struct proc *p = myproc();

  if((sstatus & SSTATUS_SPP) == 0)
    panic("kerneltrap: not from supervisor mode");
  if(intr_get() != 0)
    panic("kerneltrap: interrupts enabled");

  if((which_dev = devintr()) == 0){
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n",
           scause, r_sepc(), r_stval());
    panic("kerneltrap");
  }

  // timer interrupt scheduling
  if(which_dev == 2 && p != 0){
    mlfq_global_ticks++;

    if(p->state == RUNNING){
      p->used_ticks++;
      p->total_ticks[p->level]++;
      yield();
    }

    if(mlfq_global_ticks % 128 == 0){
      struct proc *traverse; 
      for(traverse = proc; traverse < &proc[NPROC]; traverse++){
        acquire(&traverse->lock);
        if(traverse->state == RUNNABLE){
          traverse->level = 0;
        }
        release(&traverse->lock);
      }
    }
  }

  w_sepc(sepc);
  w_sstatus(sstatus);
}

//
// clock interrupt
//
void
clockintr()
{
  if(cpuid() == 0){
    acquire(&tickslock);
    ticks++;
    wakeup(&ticks);
    release(&tickslock);
  }

  w_stimecmp(r_time() + 1000000);
}

//
// device interrupt handler
//
int
devintr()
{
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    int irq = plic_claim();

    if(irq == UART0_IRQ){
      uartintr();
    } else if(irq == VIRTIO0_IRQ){
      virtio_disk_intr();
    } else if(irq){
      printf("unexpected interrupt irq=%d\n", irq);
    }

    if(irq)
      plic_complete(irq);

    return 1;

  } else if(scause == 0x8000000000000005L){
    clockintr();
    return 2;

  } else {
    return 0;
  }
}