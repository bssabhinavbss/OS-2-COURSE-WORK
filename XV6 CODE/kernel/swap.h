#ifndef SWAP_H
#define SWAP_H

#include "types.h"
#include "spinlock.h"
#include "riscv.h"

struct proc;

#define MAX_SWAP    128
#define MAX_FRAMES  32

// PTE swap encoding
#define PTE_SWAPPED     (1L << 8)
#define PTE_SWAP_SHIFT  10
#define PTE_SWAP_MASK   (0xFF << 10)

// RAID config constants
#define NUM_DISKS         4

#define SWAP_START_BLOCK  0
#define ROTATIONAL_CONST  5

// disk scheduling constants
#define DISK_SCHED_FCFS  0
#define DISK_SCHED_SSTF  1
#define MAX_DISK_QUEUE   64

// swap slot
struct swap_slot {
  int    used;
  struct proc *proc;
  uint64 va;
  uint32 disk_block;
};

// frame table entry
struct frame_entry {
  int         used;
  struct proc *proc;
  uint64      va;
  uint64      pa;
  int         ref_bit;
  int         grace;
};

extern struct frame_entry frame_table[MAX_FRAMES];
extern struct spinlock    frame_lock;
extern int                clock_hand;

extern struct swap_slot   swap_space[MAX_SWAP];
extern struct spinlock    swap_lock;

void swap_init(void);
int  swap_alloc(void);
void swap_free(int);
void swap_write(int, char *, struct proc *, uint64, struct proc *);
void swap_read(int, char *, struct proc *);

#endif