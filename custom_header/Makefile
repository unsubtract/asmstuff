TARGETS = forkbomb forkbomb_tiny forkbomb32
all: $(TARGETS)

%: %.asm
	nasm -fbin $<
	chmod +x $@

clean:
	rm $(TARGETS) 
