#include <ulib.h>
#include <stdio.h>

const int max_child = 32;

void fk(){
    int n = 2;
    int pid;
        if ((pid = fork()) == 0) {
            cprintf("I am child %d\n", n);
            // exit(0);
        }
}

int
main(void) {
    int n, pid;
    fk();
    // for (n = 0; n < max_child; n ++) {
    //     if ((pid = fork()) == 0) {
    //         cprintf("I am child %d\n", n);
    //         exit(0);
    //     }
    //     assert(pid > 0);
    // }

    // if (n > max_child) {
    //     panic("fork claimed to work %d times!\n", n);
    // }

    // for (; n > 0; n --) {
    //     if (wait() != 0) {
    //         panic("wait stopped early\n");
    //     }
    // }

    // if (wait() == 0) {
    //     panic("wait got too many\n");
    // }

    cprintf("forktest pass.\n");
    return 0;
}

