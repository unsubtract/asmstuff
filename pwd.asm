; pwd.asm - print current working directory
;
; The getcwd syscall returns the character count (including null char),
; unlike the C function which returns a completely useless pointer.
; Return value <= 0 means error.

BITS 64

stdout equ 1
SYS_write equ 1
SYS_exit equ 60
SYS_getcwd equ 79

bufsize equ 4096

section .text
global _start

_start:
    sub rsp, bufsize
    mov eax, SYS_getcwd
    mov rdi, rsp
    mov esi, bufsize
    syscall

    test eax, eax
    jle fail

    mov byte [rsp+rax-1], `\n` ; swap \0 for newline

    mov edx, eax
    mov eax, SYS_write
    mov edi, stdout
    mov rsi, rsp
    syscall

    xor edi, edi
end:
    mov eax, SYS_exit
    syscall

fail:
    mov edi, 1
    jmp end
