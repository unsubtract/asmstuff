; echo_abibreak.asm - write command line argument strings to output
;
; This implementation is based on the observation that, at least on
; x86_64 Linux, argument strings are contiguous in memory, allowing the code to
; be more optimized (no copying memory and a singular call to write(2)).
;
; This behavior is not guaranteed by the SysV ABI or any other standard so this
; program could break at any point in the future, but it's fun regardless.

BITS 64

SYS_exit equ 60

section .text
global _start

_start:
    pop rbp ; argc
    xor edx, edx ; character counter
    mov edi, 1 ; used as stdout and also in place of immediate 0x1

    mov rsi, rsp ; in case no arguments are passed, point to stack
    sub ebp, edi ; 0x1
    cmovle edx, edi ; ensure edx >= 1 when no args
    jle print ; no args
    mov rsi, [rsi+8] ; point to argv[1]

len_loop:
    add edx, edi ; 0x1
    cmp byte [rsi+rdx-1], 0
    jnz len_loop
    mov [rsi+rdx-1], byte ' '
    sub ebp, edi ; 0x1
    jg len_loop

print:
    mov [rsi+rdx-1], byte `\n`
    mov eax, edi ; SYS_write
    syscall

exit:
    mov eax, SYS_exit
    xor edi, edi
    syscall
