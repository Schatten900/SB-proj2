section .data

texto_erro_divisao db "ERRO: DIVISAO POR ZERO",10
tam_texto_erro_divisao equ $- texto_erro_divisao

section .text

global divisao32
global divisao16
extern sair
extern mostrar_texto

divisao32:

    push ebp             ; Salva o endereço de retorno
    mov ebp, esp         ; Passa o endereço da base
    ; Realiza a divisão com 32 bits

    mov ecx, [ebp+8]     ; ecx = divisor (num2)
    cmp ecx, 0
    je erro_divisao      ; Se divisor for 0, erro
    
    mov eax, [ebp+12]    ; eax = dividendo (num1)
    cdq                  ; Estende EAX para EDX:EAX (para divisão com sinal)
    idiv ecx             ; EDX:EAX / ECX, resultado em EAX, resto em EDX

    jmp fim_divisao


divisao16:

    push ebp
    mov ebp, esp

    mov cx, [ebp+8]      ; cx = divisor (num2)
    cmp cx, 0
    je erro_divisao      ; Se divisor for 0, erro
    
    mov ax, [ebp+12]     ; ax = dividendo (num1)
    cwd                  ; Estende AX para DX:AX (para divisão com sinal)
    idiv cx              ; DX:AX / CX, resultado em AX, resto em DX

    movsx eax, ax        ; copia um valor menor (de 8 ou 16 bits) para um registrador maior (de 16, 32 ou 64 bits)

fim_divisao:
    
    mov esp, ebp
    pop ebp              ; Recupera a posicao de retorno da stack

    ret                  ; eax = valor da divisão

erro_divisao:

    ; Mostrar erro de divisão por zero
    push dword tam_texto_erro_divisao
    push dword texto_erro_divisao
    call mostrar_texto
    add esp, 8

    call sair
