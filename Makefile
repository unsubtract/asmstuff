TARGETS = echo_abibreak echo_nocopy pwd pwd_c Programming\ Language
all: $(TARGETS)

%: %.asm
	nasm -felf64 "$<"
	ld -n -s "$@.o" -o "$@"

clean:
	rm *.o $(TARGETS)
