; Programming Language.asm - see https://esolangs.org/wiki/Programming_Language
;
; Input is treated as binary instead of text, in other words the file cannot
; contain any EOL bytes (LF or CR). Because the output must always be the same
; as the input, the output deliberately omits any newline.
;
; Input is always read from stdin

BITS 64

SYS_exit equ 60

section .rodata
program: db \
"A programming language is a system of notation for writing computer programs."
program_sz equ $ - program

section .text
global _start

_start:
    mov edx, program_sz+1 ; read an extra byte to detect if input is too long
    sub rsp, rdx
    xor eax, eax ; SYS_read
    xor edi, edi ; stdin
    mov rsi, rsp
    syscall
    
    cmp eax, program_sz
    jne exit

    mov edi, 1 ; stdout
    xor edx, edx
program_cmp:
    movzx ebx, byte [program+rdx]
    cmp byte [rsp+rdx], bl
    jne exit
    add edx, edi ; 0x1
    cmp edx, eax ; program_sz
    jl program_cmp

    mov eax, edi ; SYS_write
    mov rsi, program
    syscall

exit:
    mov eax, SYS_exit
    xor edi, edi
    syscall
