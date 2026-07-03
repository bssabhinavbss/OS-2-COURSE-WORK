
#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"
#include "fs.h"       // defines BSIZE = 1024
#include "raid.h"

//  Simulated disk storage: 4 × 512 × 1024 bytes = 2 MB total

static char sim_disk[NUM_DISKS][DISK_BLOCKS][BSIZE];
static int  disk_failed[NUM_DISKS];
static int  raid_mode;
static struct spinlock raid_lock;

static char raid_copy_buf[PGSIZE];

static void
phys_write_block(int disk_id, uint32 blk, char *src)
{
  if(disk_id < 0 || disk_id >= NUM_DISKS)
    panic("raid: phys_write bad disk");
  if(blk >= DISK_BLOCKS)
    panic("raid: phys_write block out of range");
  if(disk_failed[disk_id])
    return;
  memmove(sim_disk[disk_id][blk], src, BSIZE);
}

static int
phys_read_block(int disk_id, uint32 blk, char *dst)
{
  if(disk_id < 0 || disk_id >= NUM_DISKS)
    panic("raid: phys_read bad disk");
  if(blk >= DISK_BLOCKS)
    panic("raid: phys_read block out of range");
  if(disk_failed[disk_id])
    return -1;
  memmove(dst, sim_disk[disk_id][blk], BSIZE);
  return 0;
}

static void
xor_block(char *dst, char *src)
{
  for(int i = 0; i < BSIZE; i++)
    dst[i] ^= src[i];
}

//  RAID-0: disk = lblock % 4,  phys = lblock / 4

static void
raid0_write(uint32 lb, char *src)
{
  phys_write_block(lb % NUM_DISKS, lb / NUM_DISKS, src);
}

static void
raid0_read(uint32 lb, char *dst)
{
  if(phys_read_block(lb % NUM_DISKS, lb / NUM_DISKS, dst) < 0)
    panic("raid0: disk failed");
}


//  RAID-1: write to disk 0 and disk 1; read from whichever is healthy.
//  lblock used directly as the physical block number on each mirror disk.
static void
raid1_write(uint32 lb, char *src)
{
  phys_write_block(0, lb, src);
  phys_write_block(1, lb, src);
}

static void
raid1_read(uint32 lb, char *dst)
{
  if(phys_read_block(0, lb, dst) == 0) return;
  if(phys_read_block(1, lb, dst) == 0) return;
  panic("raid1: both mirrors failed");
}

//  RAID-5: DATA_DISKS=3 data blocks per stripe + 1 parity block.
//
//  stripe   = lblock / 3
//  data_idx = lblock % 3        (0, 1, or 2)
//  parity_disk = stripe % 4
//  data disk d maps to physical disk: (parity_disk + 1 + d) % 4
//  all blocks in the stripe live at physical row = stripe on their disk.
#define DATA_DISKS 3

static int raid5_parity_disk(uint32 stripe){ return stripe % NUM_DISKS; }
static int raid5_data_disk(uint32 stripe, int d){ return (raid5_parity_disk(stripe) + 1 + d) % NUM_DISKS; }

static void
raid5_write(uint32 lb, char *src)
{
  uint32 stripe   = lb / DATA_DISKS;
  int    data_idx = lb % DATA_DISKS;
  int    this_d   = raid5_data_disk(stripe, data_idx);
  int    par_d    = raid5_parity_disk(stripe);

  phys_write_block(this_d, stripe, src);

  // Recompute parity = XOR of all data blocks in this stripe
  char parity[BSIZE];
  memset(parity, 0, BSIZE);
  for(int d = 0; d < DATA_DISKS; d++){
    int disk = raid5_data_disk(stripe, d);
    char tmp[BSIZE];
    if(phys_read_block(disk, stripe, tmp) == 0)
      xor_block(parity, tmp);
  }
  phys_write_block(par_d, stripe, parity);
}

static void
raid5_read(uint32 lb, char *dst)
{
  uint32 stripe   = lb / DATA_DISKS;
  int    data_idx = lb % DATA_DISKS;
  int    this_d   = raid5_data_disk(stripe, data_idx);
  int    par_d    = raid5_parity_disk(stripe);

  // Fast path: target disk healthy
  if(phys_read_block(this_d, stripe, dst) == 0)
    return;

  // Reconstruction: XOR all surviving disks (data + parity)
  char rec[BSIZE];
  memset(rec, 0, BSIZE);
  for(int d = 0; d < DATA_DISKS; d++){
    int disk = raid5_data_disk(stripe, d);
    if(disk == this_d) continue;
    char tmp[BSIZE];
    if(phys_read_block(disk, stripe, tmp) < 0)
      panic("raid5: two disks failed");
    xor_block(rec, tmp);
  }
  char ptmp[BSIZE];
  if(phys_read_block(par_d, stripe, ptmp) < 0)
    panic("raid5: parity disk also failed");
  xor_block(rec, ptmp);
  memmove(dst, rec, BSIZE);
}

void
raid_init(void)
{
  initlock(&raid_lock, "raid");
  raid_mode = RAID_MODE_0;
  for(int d = 0; d < NUM_DISKS; d++)
    disk_failed[d] = 0;
  memset(sim_disk, 0, sizeof(sim_disk));
}

void
raid_setmode(int mode)
{
  if(mode != RAID_MODE_0 && mode != RAID_MODE_1 && mode != RAID_MODE_5)
    panic("raid_setmode: invalid mode");
  acquire(&raid_lock);
  raid_mode = mode;
  release(&raid_lock);
}

int
raid_getmode(void)
{
  return raid_mode;
}

void
raid_fail_disk(int d)
{
  if(d < 0 || d >= NUM_DISKS) panic("raid_fail_disk");
  acquire(&raid_lock);
  disk_failed[d] = 1;
  release(&raid_lock);
}

void
raid_restore_disk(int d)
{
  if(d < 0 || d >= NUM_DISKS) panic("raid_restore_disk");
  acquire(&raid_lock);
  disk_failed[d] = 0;
  release(&raid_lock);
}

void
raid_write(uint32 lblock, char *src)
{
  acquire(&raid_lock);
  for(int i = 0; i < BLOCKS_PER_PAGE; i++){
    uint32 lb = lblock + i;
    char  *s  = src + i * BSIZE;
    switch(raid_mode){
      case RAID_MODE_0: raid0_write(lb, s); break;
      case RAID_MODE_1: raid1_write(lb, s); break;
      case RAID_MODE_5: raid5_write(lb, s); break;
      default: panic("raid_write: bad mode");
    }
  }
  release(&raid_lock);
}

void
raid_read(uint32 lblock, char *dst)
{
  acquire(&raid_lock);
  for(int i = 0; i < BLOCKS_PER_PAGE; i++){
    uint32 lb = lblock + i;
    char  *d  = dst + i * BSIZE;
    switch(raid_mode){
      case RAID_MODE_0: raid0_read(lb, d); break;
      case RAID_MODE_1: raid1_read(lb, d); break;
      case RAID_MODE_5: raid5_read(lb, d); break;
      default: panic("raid_read: bad mode");
    }
  }
  release(&raid_lock);
}

void
raid_copy(uint32 src_lblock, uint32 dst_lblock)
{
  acquire(&raid_lock);
  // Read src into scratch buffer (call internal helpers directly, lock already held)
  for(int i = 0; i < BLOCKS_PER_PAGE; i++){
    uint32 lb = src_lblock + i;
    char  *d  = raid_copy_buf + i * BSIZE;
    switch(raid_mode){
      case RAID_MODE_0: raid0_read(lb, d); break;
      case RAID_MODE_1: raid1_read(lb, d); break;
      case RAID_MODE_5: raid5_read(lb, d); break;
      default: panic("raid_copy: bad mode");
    }
  }
  // Write scratch buffer to dst
  for(int i = 0; i < BLOCKS_PER_PAGE; i++){
    uint32 lb = dst_lblock + i;
    char  *s  = raid_copy_buf + i * BSIZE;
    switch(raid_mode){
      case RAID_MODE_0: raid0_write(lb, s); break;
      case RAID_MODE_1: raid1_write(lb, s); break;
      case RAID_MODE_5: raid5_write(lb, s); break;
      default: panic("raid_copy: bad mode");
    }
  }
  release(&raid_lock);
}