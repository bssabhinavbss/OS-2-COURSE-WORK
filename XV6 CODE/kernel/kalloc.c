// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"
#include "swap.h"
#include "proc.h"

struct frame_entry frame_table[MAX_FRAMES];
struct spinlock    frame_lock;
int                clock_hand = 0;

void evict_page(int idx);
void freerange(void *pa_start, void *pa_end);

extern char end[];

struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  struct run *freelist;
} kmem;

void
kinit()
{
  initlock(&kmem.lock, "kmem");
  initlock(&frame_lock, "frame");
  freerange(end, (void*)PHYSTOP);
  for(int i = 0; i < MAX_FRAMES; i++){
    frame_table[i].used    = 0;
    frame_table[i].proc    = 0;
    frame_table[i].va      = 0;
    frame_table[i].pa      = 0;
    frame_table[i].ref_bit = 0;
    frame_table[i].grace   = 0;
  }
}

void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    kfree(p);
}

void
kfree(void *pa)
{
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  memset(pa, 1, PGSIZE);

  r = (struct run*)pa;

  acquire(&kmem.lock);
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);
}

void *
kalloc(void)
{
  struct run *r;

  acquire(&kmem.lock);
  r = kmem.freelist;
  if(r)
    kmem.freelist = r->next;
  release(&kmem.lock);

  if(r)
    memset((char*)r, 5, PGSIZE);
  return (void*)r;
}

// Clock algorithm victim selection.
// Pass 1: prefer low-priority processes (level >= 2) with ref_bit == 0.
// Pass 2: fall back to any frame with ref_bit == 0.
// Must be called with frame_lock held.
static int
clock_pick_victim(struct proc *curr)
{
  
  // Sweep 1: Try to clear ref_bits ONLY for the current process
  // and pick an unreferenced page belonging to the current process.
  for(int sweep = 0; sweep < 2 * MAX_FRAMES; sweep++){
    struct frame_entry *f = &frame_table[clock_hand];
    int idx = clock_hand;
    clock_hand = (clock_hand + 1) % MAX_FRAMES;

    if(!f->used || f->proc != curr)
      continue;

    if(f->ref_bit){
      f->ref_bit = 0;
      continue;
    }
    return idx;
  }

  // Sweep 2: If the current process has no evictable pages (or none at all),
  // fall back to the global clock algorithm across all processes.
  for(int sweep = 0; sweep < 2 * MAX_FRAMES; sweep++){
    struct frame_entry *f = &frame_table[clock_hand];
    int idx = clock_hand;
    clock_hand = (clock_hand + 1) % MAX_FRAMES;

    if(!f->used || f->proc == 0)
      continue;

    if(f->ref_bit){
      f->ref_bit = 0;
      continue;
    }

    return idx;
  }

  for(int i = 0; i < MAX_FRAMES; i++){
    if(frame_table[i].used && frame_table[i].proc != 0)
      return i;
  }

  panic("clock_pick_victim: no evictable frame");
}
char *
kalloc_user(struct proc *p, uint64 va)
{
  acquire(&frame_lock);

  // Fast path: find a free frame slot
  for(int i = 0; i < MAX_FRAMES; i++){
    if(!frame_table[i].used){
      frame_table[i].used    = 1;
      frame_table[i].proc    = p;
      frame_table[i].va      = va;
      frame_table[i].ref_bit = 1;
      frame_table[i].grace   = 0;
      release(&frame_lock);

      char *mem = kalloc();
      if(mem == 0){
        acquire(&frame_lock);
        frame_table[i].used = 0;
        frame_table[i].proc = 0;
        release(&frame_lock);
        return 0;
      }

      acquire(&frame_lock);
      frame_table[i].pa = (uint64)mem;
      release(&frame_lock);
      return mem;
    }
  }

  // All frames full: evict a victim
  int victim = clock_pick_victim(p);

  struct proc  *vp  = frame_table[victim].proc;
  uint64        vva = frame_table[victim].va;
  uint64        vpa = frame_table[victim].pa;

  // Claim the frame slot for the new allocation immediately
  frame_table[victim].used    = 1;
  frame_table[victim].proc    = p;
  frame_table[victim].va      = va;
  frame_table[victim].pa      = 0;   // updated after kalloc below
  frame_table[victim].ref_bit = 1;
  frame_table[victim].grace   = 0;

  release(&frame_lock);

  // ── Write victim page to swap ────────────────────────────────────
  int slot = swap_alloc();
  if(slot < 0){
    acquire(&frame_lock);
    frame_table[victim].used = 0;
    frame_table[victim].proc = 0;
    release(&frame_lock);
    return 0;
  }

  // swap_write: victim=vp (whose page is evicted), creditor=p (requesting process)
  swap_write(slot, (char *)vpa, vp, vva, p);

  // Update victim's PTE to mark page swapped out
  if(vp != 0 && vp->pagetable != 0){
    pte_t *pte = walk(vp->pagetable, vva, 0);
    if(pte && (*pte & PTE_V)){
      uint16 perms = PTE_FLAGS(*pte) & 0x3FF;
      *pte = ((pte_t)slot << PTE_SWAP_SHIFT) | PTE_SWAPPED | perms;
      *pte &= ~PTE_V;
      sfence_vma();
    }
  }

  if(vp != 0){
    vp->pages_evicted++;
    vp->pages_swapped_out++;
    vp->resident_pages--;
  }

  
  kfree((void *)vpa);

  char *mem = kalloc();
  if(mem == 0){
    acquire(&frame_lock);
    frame_table[victim].used = 0;
    frame_table[victim].proc = 0;
    release(&frame_lock);
    return 0;
  }

  acquire(&frame_lock);
  frame_table[victim].pa = (uint64)mem;
  release(&frame_lock);

  return mem;
}

void
evict_page(int idx)
{
  acquire(&frame_lock);

  struct frame_entry *f = &frame_table[idx];
  struct proc *p  = f->proc;
  uint64      va  = f->va;

  if(p == 0 || p->state == UNUSED){
    f->used = 0;
    f->proc = 0;
    release(&frame_lock);
    return;
  }

  f->used = 0;
  f->proc = 0;
  release(&frame_lock);

  acquire(&p->lock);

  pte_t *pte = walk(p->pagetable, va, 0);
  if(pte == 0 || (*pte & PTE_V) == 0){
    release(&p->lock);
    return;
  }

  uint64 pa = PTE2PA(*pte);

  int swap_idx = swap_alloc();
  if(swap_idx < 0){
    release(&p->lock);
    return;
  }

  swap_write(swap_idx, (char*)pa, p, va, p);
  *pte = ((pte_t)swap_idx << PTE_SWAP_SHIFT) | PTE_SWAPPED;
  kfree((void*)pa);

  p->pages_evicted++;
  p->pages_swapped_out++;
  p->resident_pages--;

  release(&p->lock);
  sfence_vma();
}