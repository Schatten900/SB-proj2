ASM=nasm
ASMFLAGS=-f elf32
LD=ld
LDFLAGS=-m elf_i386

OBJ=CALCULADORA.o SOMA.o SUBTRACAO.o MULTIPLICACAO.o DIVISAO.o MOD.o EXPONENCIACAO.o

calculadora: $(OBJ)
	$(LD) $(LDFLAGS) $(OBJ) -o calculadora

%.o: %.asm
	$(ASM) $(ASMFLAGS) $< -o $@

clean:
	rm -f *.o calculadora