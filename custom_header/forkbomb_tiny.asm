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
    dq 0 ; e_shoff
phdr:
    dd 1 ; e_flags clobbered by p_type
    dw 1 ; e_ehsize clobbered by p_flags (first two bytes)
    dw 0x38 ; p_flags (last two bytes) clobbered by e_phentsize
    dw 1 ; p_offset (first two bytes) clobbered by e_phnum
    dw 0 ; p_offset/e_shentsize
    dd 0 ; p_offset/e_shnum, e_shstrndx
    dq load_addr + 1 ; + 1 due to clobbering of p_offset
    dq load_addr + 1 ; ^
    dq file_end
    dq file_end
    dq 0x10

file_end:
