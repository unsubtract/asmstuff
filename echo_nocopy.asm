; echo_nocopy.asm - write command line argument strings to output
;
; This implementation computes the length of the argument string, swaps the
; null char for a space and then calls write(2), repeating for each string.
;
; This can be considered a naive appraoch because syscalls could be more
; expensive than copying on long inputs.

BITS 64

SYS_exit equ 60

section .text
global _start

_start:
    pop rbp ; argc
    mov edi, 1 ; passed to write() and also used instead of immediate 0x1
    mov ebx, edi ; argument counter
    jmp check

arg_loop:
    mov rsi, [rsp+rbx*8]
strlen_loop:
    add edx, edi ; 0x1
    cmp byte [rsi+rdx-1], 0
    jne strlen_loop

    mov [rsi+rdx-1], byte ' '

    add ebx, edi ; 0x1
    cmp ebx, ebp
    jl space
    sub edx, edi ; 0x1
    space:

    mov eax, edi ; SYS_write
    syscall
check:
    xor edx, edx ; character counter
    cmp ebx, ebp
    jl arg_loop

exit:
    mov eax, edi ; SYS_write
    mov edx, edi ; 0x1
    mov rsi, rsp
    mov [rsp], byte `\n`
    syscall

    mov eax, SYS_exit
    xor edi, edi
    syscall
