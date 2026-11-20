#include <stdio.h>
#include <unistd.h>

int main() {
    char program[] = "/bin/cat";
    char filename[] = "/etc/passwd";

    char *args[] = {program, filename, NULL};
    char *envs[] = {NULL};

    execve(program, args, envs);

    perror("execve failed");
    return 1;
}