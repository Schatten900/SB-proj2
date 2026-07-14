ASM=nasm
ASMFLAGS=-f elf32
LD=ld
LDFLAGS=-m elf_i386

OBJ=calculadora.o soma.o subtracao.o multiplicacao.o divisao.o mod.o exponenciacao.o

calculadora: $(OBJ)
	$(LD) $(LDFLAGS) $(OBJ) -o calculadora

%.o: %.asm
	$(ASM) $(ASMFLAGS) $< -o $@

clean:
	rm -f *.o calculadora