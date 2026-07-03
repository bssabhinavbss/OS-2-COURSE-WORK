
#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"

#include "fs.h"          
#include "sleeplock.h"   
#include "buf.h"         // 

#include "disksched.h"


//  Constants


#define ROTATIONAL_CONST   5    // added to every seek distance
#define MAX_DISK_QUEUE     64   // maximum pending requests

//  Request queue

struct disk_req {
  struct buf *buf;       
  int         write;      
  uint        blockno;    
  int         priority;   
  int         pid;        
  int         valid;      
  uint        seq;        
};

static struct disk_req  dq[MAX_DISK_QUEUE];
static int              dq_size;          
static struct spinlock  dq_lock;
static uint             dq_seq;           

//  Disk head state

static uint  current_head;       
static int   sched_policy;       


//  Global stats 

static uint64 total_latency;     
static uint64 total_ops;         

//  disksched_init

void
disksched_init(void)
{
  initlock(&dq_lock, "disksched");
  dq_size      = 0;
  current_head = 0;
  sched_policy = DISK_SCHED_FCFS;
  total_latency = 0;
  total_ops     = 0;
  dq_seq        = 0;
  for(int i = 0; i < MAX_DISK_QUEUE; i++){
  dq[i].valid = 0;
  }
}

//  disksched_set_policy

void
disksched_set_policy(int policy)
{
  acquire(&dq_lock);
  if(policy != DISK_SCHED_FCFS && policy != DISK_SCHED_SSTF){
    panic("disksched_set_policy: invalid policy");
  }
  sched_policy = policy;
  release(&dq_lock);
}

int
disksched_get_policy(void)
{
  return sched_policy;
}
//  disksched_get_stats
void
disksched_get_stats(uint64 *out_total_ops, uint64 *out_avg_latency)
{
  acquire(&dq_lock);
  *out_total_ops = total_ops;
  if(total_ops > 0) {
    *out_avg_latency = (total_latency / total_ops);
  } else {
    *out_avg_latency = 0;
  }
  release(&dq_lock);
}
//  Internal: find a free slot in dq[]
static int
dq_alloc_slot(void)
{
  for(int i = 0; i < MAX_DISK_QUEUE; i++){
    if(!dq[i].valid){
      return i;
    }
  }
  return -1;
}
//  Internal: FCFS selection
static int
pick_fcfs(void)
{
  int  best     = -1;
  uint best_seq = 0xFFFFFFFF;

  for(int i = 0; i < MAX_DISK_QUEUE; i++){
    if(!dq[i].valid) continue;
    if(dq[i].seq < best_seq){
      best_seq = dq[i].seq;
      best     = i;
    }
  }
  return best;
}


// Internal: SSTF selection

static int
pick_sstf(void)
{
  int  best      = -1;
  uint best_dist = 0xFFFFFFFF;
  int  best_prio = 0x7FFFFFFF;

  for(int i = 0; i < MAX_DISK_QUEUE; i++){
    if(!dq[i].valid) continue;

    uint dist;
    if(dq[i].blockno > current_head) {
      dist = (dq[i].blockno - current_head);
    } else {
      dist = (current_head - dq[i].blockno);
    }

    if((dist < best_dist) ||
       (dist == best_dist && dq[i].priority < best_prio)) {
      best      = i;
      best_dist = dist;
      best_prio = dq[i].priority;
    }
  }
  return best;
}


//Internal: compute latency and update stats


static uint
compute_and_record_latency(uint blockno, int pid)
{
  (void)pid;  

  uint seek;
  if(blockno > current_head) {
    seek = (blockno - current_head);
  } else {
    seek = (current_head - blockno);
  }
  uint latency = seek + ROTATIONAL_CONST;

  // update global stats only 
  total_latency += latency;
  total_ops++;

  return latency;
}

void
disksched_submit(struct buf *b, int write)
{
  acquire(&dq_lock);

  //  Enqueue the new request 
  int slot = dq_alloc_slot();
  if(slot < 0){
    panic("disksched: queue full");
  }

  struct proc *p = myproc();
  dq[slot].buf      = b;
  dq[slot].write    = write;
  dq[slot].blockno  = b->blockno;
  if(p != 0) {
    dq[slot].priority = p->level;
  } 
  else {
    dq[slot].priority = 99;   // 99 = kernel/no process
  }

  if(p != 0) {
    dq[slot].pid = p->pid;
  } 
  else {
    dq[slot].pid = -1;
  }
  dq[slot].seq      = dq_seq++;
  dq[slot].valid    = 1;
  dq_size++;

  // Pick next request according to policy 
  int chosen;
  if(sched_policy == DISK_SCHED_SSTF) {
    chosen = pick_sstf();
  } 
  else {
    chosen = pick_fcfs();
  }

  if(chosen < 0) {
    release(&dq_lock);
    return;   // nothing to do
  }

  //Extract chosen request from queue 
  struct buf *chosen_buf   = dq[chosen].buf;
  int         chosen_write = dq[chosen].write;
  uint        chosen_block = dq[chosen].blockno;
  int         chosen_pid   = dq[chosen].pid;

  dq[chosen].valid = 0;
  dq_size--;

  //Compute latency and move disk head
  compute_and_record_latency(chosen_block, chosen_pid);
  current_head = chosen_block;

  release(&dq_lock);

  //Perform the actual I/O (outside the lock) 
  virtio_disk_rw(chosen_buf, chosen_write);
}

void
disksched_flush(void)
{
  for(;;){
    acquire(&dq_lock);
    if(dq_size == 0){
      release(&dq_lock);
      return;
    }

    int chosen;
    if(sched_policy == DISK_SCHED_SSTF) {
      chosen = pick_sstf();
    } else {
      chosen = pick_fcfs();
    }
    if(chosen < 0) {
      release(&dq_lock);
      return;
    }

    struct buf *chosen_buf   = dq[chosen].buf;
    int         chosen_write = dq[chosen].write;
    uint        chosen_block = dq[chosen].blockno;
    int         chosen_pid   = dq[chosen].pid;

    dq[chosen].valid = 0;
    dq_size--;

    compute_and_record_latency(chosen_block, chosen_pid);
    current_head = chosen_block;

    release(&dq_lock);

    virtio_disk_rw(chosen_buf, chosen_write);
  }
}