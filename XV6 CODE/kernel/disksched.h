#ifndef DISKSCHED_H
#define DISKSCHED_H

#include "types.h"
#define DISK_SCHED_FCFS   0
#define DISK_SCHED_SSTF   1

// Called once from during boot
void disksched_init(void);

// Switch scheduling policy at runtime called by setdisksched syscall
void disksched_set_policy(int policy);

// Return current policy
int  disksched_get_policy(void);

// Submit a buf for I/O replaces direct virtio_disk_rw calls in bio.c
// write = 0 for read, 1 for write
void disksched_submit(struct buf *b, int write);

// Drain all pending requests in queue order 
void disksched_flush(void);

// Get global stats: total ops and average latency
void disksched_get_stats(uint64 *out_total_ops, uint64 *out_avg_latency);

#endif 