# Calculadora de Inteiros IA-32 (16 e 32 bits)

## Descrição

Projeto desenvolvido em **Assembly IA-32** com o objetivo de consolidar conceitos de programação em baixo nível, como passagem de parâmetros pela pilha, retorno de valores pelo registrador `EAX`, modularização do código e utilização de chamadas de sistema do Linux.

A calculadora permite ao usuário escolher entre operações com inteiros de **16 bits** ou **32 bits**.

### Operações implementadas

* Soma
* Subtração
* Multiplicação
* Divisão
* Exponenciação
* Módulo (MOD)

---

## Ambiente de desenvolvimento

O projeto foi desenvolvido e testado utilizando:

* **Sistema Operacional:** Linux
* **Montador:** NASM
* **Ligador:** GNU LD

---

## Compilação

O projeto é modularizado em diversos arquivos `.asm`. A compilação e a ligação de todos os módulos são realizadas automaticamente pelo **Makefile**.

No diretório do projeto, execute:

```bash
make
```

Esse comando compila todos os módulos, realiza a ligação dos arquivos objeto (`.o`) e gera o executável `calculadora`.

---

## Compilação manual (opcional)

Caso deseje compilar manualmente, utilize os comandos abaixo:

```bash
nasm -f elf32 CALCULADORA.asm -o CALCULADORA.o
nasm -f elf32 SOMA.asm -o SOMA.o
nasm -f elf32 SUBTRACAO.asm -o SUBTRACAO.o
nasm -f elf32 MULTIPLICACAO.asm -o MULTIPLICACAO.o
nasm -f elf32 DIVISAO.asm -o DIVISAO.o
nasm -f elf32 MOD.asm -o MOD.o
nasm -f elf32 EXPONENCIACAO.asm -o EXPONENCIACAO.o

ld -m elf_i386 \
CALCULADORA.o \
SOMA.o \
SUBTRACAO.o \
MULTIPLICACAO.o \
DIVISAO.o \
MOD.o \
EXPONENCIACAO.o \
-o calculadora
```

---

## Execução

Após a compilação, execute:

```bash
./calculadora
```

---

## Limpeza

Para remover os arquivos objeto (`.o`) e o executável gerado:

```bash
make clean
```
