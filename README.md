# asmstuff

Various x86\_64 Linux assembly things; build with `make` (requires nasm)

See the comments within the sources for details about what they do

- `echo*.asm`: print command line arguments that were passed
- `pwd*.asm`: print current working directory
- `Programming Language.asm`: see https://esolangs.org/wiki/Programming_Language

---

The [`custom_header`](./custom_header) directory contains programs written
using the techniques described by
[A Whirlwind Tutorial on Creating Really Teensy ELF Executables for Linux](http://www.muppetlabs.com/~breadbox/software/tiny/teensy.html)
and [Tiny ELF Files: Revisited in 2021](https://nathanotterness.com/2021/10/tiny_elf_modernized.html),
where an optimal ELF header is manually created by inserting the necessary
bytes into the assembly code and the linker is skipped.
<br>The [Wikipedia article on ELF](https://en.wikipedia.org/wiki/Executable_and_Linkable_Format)
is also a useful resource.

The entire program fits within 7 bytes of padding that exist within the header:
```nasm
_start:
    push SYS_fork
    pop rax
    syscall
    jmp _start
```
This is a fork-bomb, which is probably the only "interesting" thing you can do
in 7 bytes (your other options are to run an infinite loop, or just exit).
<br>Run it with caution (see `ulimit`).

The final binary is 120 bytes on x86_64, and 76 bytes on i386 (due to
all the 8-byte fields being 4-bytes instead). A 104-byte x86_64 binary is also
available, which completely breaks the SysV ABI by overlapping and clobbering
various bits of data in ways that Linux just so happens to not care about.
