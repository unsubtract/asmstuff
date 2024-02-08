; echo_abibreak.asm - write command line argument strings to output
;
; This implementation is based on the observation that, at least on
; x86_64 Linux, argument strings are contiguous in memory, allowing the code to
; be more optimized (no copying memory and a singular call to write(2)).
;
; This behavior is not guaranteed by the ABI or any other standard so this code
; could break at any point in the future, but it's fun regardless.

BITS 64

stdout equ 1
SYS_write equ 1
SYS_exit equ 60

section .text
global _start

_start:
    pop rbp ; argc
    xor edx, edx ; character counter

    mov rsi, rsp ; if no arguments are passed, point to stack
    cmp rbp, 1
    cmovg rsi, [rsp+8] ; otherwise point to argv[1]
    setle dl ; ensure edx >= 1 when jumping to print

arg_loop:
    sub ebp, 1
    jle print
char_loop:
    cmp byte [rsi+rdx], 0
    lea edx, [edx+1] ; use lea to avoid setting flags
    jnz char_loop
    mov [rsi+rdx-1], byte ' '
    jmp arg_loop

print:
    mov [rsi+rdx-1], byte `\n`
    mov edi, stdout
    mov eax, SYS_write
    syscall

exit:
    mov eax, SYS_exit
    xor edi, edi
    syscall
    nop ; increase the text section to 69 bytes at the request of peers
    nop
