section .data

texto_overflow db "OCORREU OVERFLOW",10
tam_texto_overflow equ $- texto_overflow 

section .text

global subtracao32
global subtracao16
extern sair
extern mostrar_texto

subtracao32:

    push ebp             ; Salva o endereço de retorno
    mov ebp, esp         ; Passa o endereço da base
    ; Realiza a subtração com 32 bits

    mov eax,[ebp+8]     ; num2
    sub eax,[ebp+12]     ; realiza num1 - num2 e salva em eax
    
    jo overflow                  ; Verifica se houve overflow

    jmp fim_subtracao


subtracao16:

    push ebp
    mov ebp,esp

    mov ax,[ebp+8]      ; num2
    sub ax,[ebp+12]     ; realiza num1 - num2 e salva em ax
   
    jo overflow          ; Verifica se houve overflow

    movsx eax, ax        ; copia um valor menor (de 8 ou 16 bits) para um registrador maior (de 16, 32 ou 64 bits)

fim_subtracao:
    
    mov esp, ebp
    pop ebp             ; Recupera a posicao de retorno da stack

    ret                 ; eax = valor da subtração

overflow:

    ; Mostrar que ocorreu overflow
    push dword tam_texto_overflow
    push dword texto_overflow
    call mostrar_texto
    add esp, 8
    
    call sair
