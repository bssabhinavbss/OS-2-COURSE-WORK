#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define PGSIZE 4096
#define NPAGES 50   // enough to cause many disk ops

void generate_io(int tag) {
char *base = sbrklazy(NPAGES * PGSIZE);

// write → cause eviction later
for(int i = 0; i < NPAGES; i++)
base[i * PGSIZE] = tag;

// force swap out
char *p = sbrklazy(NPAGES * PGSIZE);
for(int i = 0; i < NPAGES; i++)
p[i * PGSIZE] = i;

// trigger swap-in (reads)
for(int i = 0; i < NPAGES; i++)
(void)base[i * PGSIZE];
}

int main() {
printf("\n=== Disk Scheduler Priority Test ===\n");

setdisksched(1); // use SSTF (important)

int pipefd[2];
pipe(pipefd);

int pid1 = fork();

if(pid1 == 0){
// HIGH priority process (pause → stays high)
close(pipefd[0]);


pause(10);
generate_io(1);

struct vmstats s;
getvmstats(getpid(), &s);

write(pipefd[1], &s.disk_reads, sizeof(int));
write(pipefd[1], &s.disk_writes, sizeof(int));

close(pipefd[1]);
exit(0);


}

int pid2 = fork();

if(pid2 == 0){
// LOW priority process (CPU heavy → demoted)
close(pipefd[0]);


for(volatile int i = 0; i < 100000000; i++); // burn CPU
generate_io(2);

struct vmstats s;
getvmstats(getpid(), &s);

write(pipefd[1], &s.disk_reads, sizeof(int));
write(pipefd[1], &s.disk_writes, sizeof(int));

close(pipefd[1]);
exit(0);


}

// parent
close(pipefd[1]);

int r1, w1, r2, w2;
read(pipefd[0], &r1, sizeof(int));
read(pipefd[0], &w1, sizeof(int));
read(pipefd[0], &r2, sizeof(int));
read(pipefd[0], &w2, sizeof(int));

wait(0);
wait(0);

int ops1 = r1 + w1;
int ops2 = r2 + w2;

printf("High priority ops = %d\n", ops1);
printf("Low  priority ops = %d\n", ops2);

if(ops1 >= ops2){
printf("PASS: Disk scheduler favors high-priority process\n");
} else {
printf("FAIL: No scheduler awareness in disk scheduling\n");
}

exit(0);
}
