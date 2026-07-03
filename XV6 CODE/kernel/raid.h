#ifndef RAID_H
#define RAID_H

#include "types.h"

#define NUM_DISKS       4     // number of simulated disks
#define DISK_BLOCKS     512   // blocks per simulated disk
#define BLOCKS_PER_PAGE 4

#define RAID_MODE_0     0     // striping
#define RAID_MODE_1     1     // mirroring (uses disks 0 and 1)
#define RAID_MODE_5     5     // striping with distributed XOR parity

//  Public API

void raid_init(void);

// Switch RAID mode at runtime (0, 1, or 5)
void raid_setmode(int mode);

// Return current RAID mode
int  raid_getmode(void);

// Read PGSIZE bytes from logical swap block lblock into dst
void raid_read(uint32 lblock, char *dst);

// Write PGSIZE bytes from src to logical swap block lblock
void raid_write(uint32 lblock, char *src);

// Copy one swap slot to another used in uvmcopy for fork
void raid_copy(uint32 src_lblock, uint32 dst_lblock);

// Mark/restore a disk as failed ,for RAID-5 reconstruction testing
void raid_fail_disk(int disk_id);
void raid_restore_disk(int disk_id);

#endif // RAID_H