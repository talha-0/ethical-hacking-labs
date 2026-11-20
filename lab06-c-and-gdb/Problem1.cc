#include <stdio.h>

int main() {
    for (int i = -65536; i <= 65535; i++) {
        printf("%d 0x%08x\n", i, (unsigned int)i);
    }

    return 0;
}