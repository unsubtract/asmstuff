BITS 32

load_addr equ 0x08048000
SYS_fork equ 2

ehdr:
    db 0x7f, "ELF"
    db 1
    db 1
    db 1
    db 0
    db 0
_start: ; entire program fits in e_ident[EI_PAD]
    push SYS_fork
    pop eax
    int 0x80
    jmp _start
; end
    dw 2
    dw 0x03
    dd 1
    dd _start + load_addr
    dd phdr
    dd 0
    dd 0
    dw 52
    dw 0x20
    ; can safely overlap with program header without corrupting anything
    ; dw 1
    ; dw 0
    ; dw 0
    ; dw 0

phdr:
    dd 1
    dd 0
    dd load_addr
    dd load_addr
    dd file_end
    dd file_end
    dd 1
    dd 0x10

file_end:
