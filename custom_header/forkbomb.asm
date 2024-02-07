BITS 64

load_addr equ 0x400000
SYS_fork equ 57

ehdr:
    db 0x7f, "ELF"
    db 2
    db 1
    db 1
    db 0
    db 0
_start: ; entire program fits in e_ident[EI_PAD]
    push SYS_fork
    pop rax
    syscall
    jmp _start
; end
    dw 2
    dw 0x3e
    dd 1
    dq _start + load_addr
    dq phdr
    dq 0
    dd 0
    dw 64
    dw 0x38
    dw 1
    dw 0
    dw 0
    dw 0

phdr:
    dd 1
    dd 1
    dq 0
    dq load_addr
    dq load_addr
    dq file_end
    dq file_end
    dq 0x10

file_end:
