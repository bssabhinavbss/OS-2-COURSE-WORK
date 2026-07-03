#ifndef _MLFQ_H_
#define _MLFQ_H_

#define MLFQ_LEVELS 4
#define BOOST_TICKS 128

// Declare only (no definition here)
extern int quantum_times[MLFQ_LEVELS];

struct mlfqinfo {
    int level;
    int ticks[MLFQ_LEVELS];
    int times_scheduled;
    int total_syscalls;
};

#endif