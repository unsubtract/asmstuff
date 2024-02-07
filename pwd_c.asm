; pwd_c.asm - print current working directory
;
; This implementation assumes the getcwd syscall behaves like the C library
; function (see getcwd(3)) where it returns nothing useful. 
; This is untrue of the syscall (see pwd.asm) but it works anyways.

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

    xor edx, edx
length_loop:
    movzx eax, byte [rsp+rdx]
    add edx, 1
    test eax, eax
    jne length_loop

    mov byte [rsp+rdx-1], `\n` ; swap \0 for newline

    mov eax, SYS_write
    mov edi, stdout
    mov rsi, rsp
    ; edx passed as-is
    syscall

    xor edi, edi
end:
    mov eax, SYS_exit
    syscall

fail:
    mov edi, 1
    jmp end
