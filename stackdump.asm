; stackdump.asm - dump memory under stack to stdout (until a segfault occurs)
; used to assist in making echo_abibreak.asm

BITS 64

stdout equ 1
SYS_write equ 1

section .text
global _start

_start:
    mov eax, 1
    mov edi, 1
    mov rsi, rsp
    mov edx, 1
    syscall
    inc rsp
    jmp _start
