; echo_nocopy.asm - write command line argument strings to output
;
; This implementation computes the length of the argument string, swaps the
; null char for a space and then calls write(2), repeating for each string.
;
; This can be considered a naive appraoch because syscalls could be more
; expensive than copying on long inputs.

BITS 64

stdout equ 1
SYS_write equ 1
SYS_exit equ 60

section .text
global _start

_start:
    pop rbp ; argc
    mov ebx, 1 ; argument counter
    jmp check

arg_loop:
    mov rsi, [rsp+rbx*8]
strlen_loop:
    cmp byte [rsi+rdx], 0
    lea edx, [edx+1] ; use lea to avoid setting flags
    jne strlen_loop

    mov [rsi+rdx-1], byte ' '

    add ebx, 1
    cmp ebx, ebp
    jl space
    sub edx, 1
    space:

    mov eax, SYS_write
    mov edi, stdout
    syscall
check:
    xor edx, edx ; character counter
    cmp ebx, ebp
    jl arg_loop

exit:
    mov eax, SYS_write
    mov edi, stdout
    mov edx, 1
    mov rsi, rsp
    mov [rsp], byte `\n`
    syscall

    mov eax, SYS_exit
    xor edi, edi
    syscall
