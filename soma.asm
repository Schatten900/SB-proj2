
section .data

texto_overflow db "OCORREU OVERFLOW",10
tam_texto_overflow equ $- texto_overflow 

section .text

global soma
extern ler_int16
extern ler_int32
extern mostrar_texto

soma:

    push ebp             ; Salva o endereço de retorno
    mov ebp, esp         ; Passa o endereço da base

    mov ecx, [ebp+8]     ; Pega a precisao

    cmp byte [ecx],'0'   ; Se precisao = 0 -> soma16 bits
    je soma_16

    ; Realiza a soma com 32 bits

    call ler_int32       ; eax = valor inteiro lido
    mov ebx, eax         ; ebx = primeiro valor lido

    call ler_int32       ; le o segundo numero inteiro
    add eax, ebx         ; realiza a soma dos dois valores
    jo overflow          ; Verifica se houve overflow

    jmp fim_soma


soma_16:

    call ler_int16       ; eax = valor inteiro lido
    mov bx, ax           ; ebx = primeiro valor lido
    call ler_int16       ; le o segundo numero inteiro
    add ax, bx         ; realiza a soma dos dois valores    
    jo overflow          ; Verifica se houve overflow

    movsx eax, ax        ; copia um valor menor (de 8 ou 16 bits) para um registrador maior (de 16, 32 ou 64 bits)

fim_soma:
    
    mov esp, ebp
    pop ebp             ; Recupera a posicao de retorno da stack

    ret                 ; eax = valor da soma

overflow:

    ; Mostrar que ocorreu overflow
    push dword tam_texto_overflow
    push dword texto_overflow
    call mostrar_texto 
    add esp, 8      ; Desempilha os dados

    jmp sair        ; Fechar o programa