; pwd.asm - print current working directory
;
; The getcwd syscall returns the character count (including null char),
; unlike the C function which returns a completely useless pointer.
; Return value <= 0 means error.

BITS 64

SYS_exit equ 60
SYS_getcwd equ 79

bufsize equ 4096

section .text
global _start

_start:
    mov esi, bufsize
    sub rsp, rsi
    mov eax, SYS_getcwd
    mov rdi, rsp
    syscall

    mov edi, 1 ; stdout and/or EXIT_FAILURE
    test eax, eax
    jle end

    mov byte [rsp+rax-1], `\n` ; swap \0 for newline

    mov edx, eax
    mov eax, edi ; SYS_write
    mov rsi, rsp
    syscall

    xor edi, edi
end:
    mov eax, SYS_exit
    syscall
