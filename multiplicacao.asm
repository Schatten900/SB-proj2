section .data

texto_overflow db "OCORREU OVERFLOW",10
tam_texto_overflow equ $- texto_overflow 


section .text

global multi
extern ler_int16
extern ler_int32
extern mostrar_texto

multi:
    
    push ebp                ; Carrega o endereço de retorno
    mov ebp,esp             ; Prepara a stack para as operacoes

    mov ecx, [ebp+8]        ; Pega a precisao

    cmp byte[ecx],'0'
    je multi_16 

    ; Realiza a multiplicacao 32 bits

    call ler_int32         ; eax = valor lido
    mov ebx, eax           ; ebx = valor lido

    call ler_int32          
    imul ebx            ; EDX:EAX = produto completo
    jo overflow         ; Verifica se houve um overflow

    jmp fim_multi


multi_16:

    call ler_int16         ; eax = valor lido
    push eax               ; Salva o valor de eax na pilha

    call ler_int16

    pop ebx                 ; pega o valor do valor lido
    imul bx                 ; DX:AX = produto completo de 64 bits
    jo overflow             ; Verifica se houve um overflow

    movsx eax,ax              ; passa o valor de ax para eax


fim_multi:

    ; Faz a descarga do endereço de retorno
    mov esp,ebp
    pop ebp

    ret             ; eax = resultado da multiplicacao


overflow:

    ; Mostrar que ocorreu overflow
    push dword tam_texto_overflow
    push dword texto_overflow
    call mostrar_texto 
    add esp, 8      ; Desempilha os dados

    jmp sair        ; Fechar o programa