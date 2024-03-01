; pwd_c.asm - print current working directory
;
; This implementation assumes the getcwd syscall behaves like the C library
; function (see getcwd(3)) where it returns nothing useful. 
; This is untrue of the syscall (see pwd.asm) but it works anyways.

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

    xor edx, edx
length_loop:
    movzx eax, byte [rsp+rdx]
    add edx, edi ; 0x1
    test eax, eax
    jne length_loop

    mov byte [rsp+rdx-1], `\n` ; swap \0 for newline

    mov eax, edi ; SYS_write
    mov rsi, rsp
    ; edx passed as-is
    syscall

    xor edi, edi
end:
    mov eax, SYS_exit
    syscall
