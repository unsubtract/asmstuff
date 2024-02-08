; Programming Language.asm - see https://esolangs.org/wiki/Programming_Language
; Reads binary data on stdin

BITS 64

stdout equ 1
stdin equ 0
SYS_read equ 0
SYS_write equ 1
SYS_exit equ 60

section .rodata
program: db \
"A programming language is a system of notation for writing computer programs."
program_sz equ $ - program

section .text
global _start

_start:
    sub rsp, program_sz+1
    xor eax, eax ; SYS_read
    xor edi, edi ; stdin
    mov rsi, rsp
    mov edx, program_sz+1
    syscall
    
    cmp eax, program_sz
    jne exit

    xor edx, edx
    program_cmp:
    movzx eax, byte [program+rdx]
    cmp al, byte [rsp+rdx]
    jne exit
    add edx, 1
    cmp edx, program_sz
    jl program_cmp

    mov eax, SYS_write
    mov edi, stdout
    mov rsi, program
    syscall

exit:
    mov eax, SYS_exit
    xor edi, edi
    syscall
