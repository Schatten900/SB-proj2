section .data

texto_overflow db "OCORREU OVERFLOW",10
tam_texto_overflow equ $- texto_overflow 


section .text

global multi16
global multi32
extern sair
extern mostrar_texto

multi32:
    
    push ebp                ; Carrega o endereço de retorno
    mov ebp,esp             ; Prepara a stack para as operacoes

    ; Realiza a multiplicacao 32 bits

    mov eax,[ebp+8]     ; eax = num2

    imul [ebp+12]       ; EDX:EAX = produto completo
    jo overflow         ; Verifica se houve um overflow

    jmp fim_multi


multi16:

    push ebp                ; Carrega o endereço de endereço
    mov ebp,esp             ; Prepara o ebp para as operacoes

    mov ax,[ebp+8]          ; ax = num2

    imul [ebp+12]           ; DX:AX = produto completo de 64 bits
    jo overflow             ; Verifica se houve um overflow

    movsx eax,ax            ; passa o valor de ax para eax


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