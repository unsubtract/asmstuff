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

    mov edi, 1 ; stdout, passed to write()
    mov rsi, program ; also passed to write
    mov edx, eax ;     ^

program_cmp:
    movzx ebx, byte [rsi+rax]
    cmp bl, byte [rsp+rax]
    jne exit
    sub eax, edi ; 0x1
    jge program_cmp

    mov eax, edi ; SYS_write
    syscall

exit:
    mov eax, SYS_exit
    xor edi, edi
    syscall
