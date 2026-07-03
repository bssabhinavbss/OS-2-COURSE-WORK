#include "kernel/types.h"
#include "user/user.h"

void print_stats(char *msg) {
    struct vmstats s;
    if(getvmstats(getpid(), &s) < 0){
        printf("getvmstats failed\n");
        return;
    }

    printf("%s\n", msg);
    printf("faults=%d evicted=%d in=%d out=%d resident=%d\n",
        s.page_faults,
        s.pages_evicted,
        s.pages_swapped_in,
        s.pages_swapped_out,
        s.resident_pages);
}

int main() {
    print_stats("Before access");

    char *p = sbrklazy(5 * 4096);

    for(int i = 0; i < 5; i++){
        p[i * 4096] = 'A';
    }

    print_stats("After access");

    exit(0);
}
