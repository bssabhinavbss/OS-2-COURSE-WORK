#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"
#include "swap.h"
#include "raid.h"

struct swap_slot swap_space[MAX_SWAP];
struct spinlock  swap_lock;

// Simulated disk head position for the swap device.
// Protected by swap_lock.
static uint32 swap_head = 0;

void
swap_init(void)
{
  initlock(&swap_lock, "swap");
  raid_init();

  for(int i = 0; i < MAX_SWAP; i++){
    swap_space[i].used       = 0;
    swap_space[i].proc       = 0;
    swap_space[i].va         = 0;
    swap_space[i].disk_block = 0;
  }
}

int
swap_alloc(void)
{
  acquire(&swap_lock);
  for(int i = 0; i < MAX_SWAP; i++){
    if(!swap_space[i].used){
      swap_space[i].used = 1;
      release(&swap_lock);
      return i;
    }
  }
  release(&swap_lock);
  return -1;
}

void
swap_free(int slot)
{
  acquire(&swap_lock);
  swap_space[slot].used = 0;
  swap_space[slot].proc = 0;
  swap_space[slot].va   = 0;
  release(&swap_lock);
}
void
swap_write(int slot, char *pa, struct proc *victim, uint64 va, struct proc *creditor)
{
  acquire(&swap_lock);
  uint32 blk = SWAP_START_BLOCK + (uint32)slot * BLOCKS_PER_PAGE;
  swap_space[slot].disk_block = blk;
  swap_space[slot].proc       = victim;
  swap_space[slot].va         = va;

  // Compute latency: |current_head - requested_block| + C
  uint32 seek = (blk > swap_head) ? (blk - swap_head) : (swap_head - blk);
  uint32 latency = seek + ROTATIONAL_CONST;
  swap_head = blk;   // move head to served block
  release(&swap_lock);

  raid_write(blk, pa);

  // Credit the process that triggered the eviction.
  if(creditor != 0){
    creditor->disk_writes++;
    creditor->total_disk_latency += latency;
    creditor->disk_ops++;
  }
}
void
swap_read(int slot, char *pa, struct proc *creditor)
{
  acquire(&swap_lock);
  uint32 blk = swap_space[slot].disk_block;

  // Compute latency: |current_head - requested_block| + C
  uint32 seek = (blk > swap_head) ? (blk - swap_head) : (swap_head - blk);
  uint32 latency = seek + ROTATIONAL_CONST;
  swap_head = blk;   // move head to served block
  release(&swap_lock);

  raid_read(blk, pa);

  // Credit the process passed explicitly from the fault handler.
  if(creditor != 0){
    creditor->disk_reads++;
    creditor->total_disk_latency += latency;
    creditor->disk_ops++;
  }
}
