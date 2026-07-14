section .data

texto_divisao_zero db "ERRO: Divisao por zero",10
tam_texto_divisao_zero equ $- texto_divisao_zero

section .text

global divisao32
global divisao16
extern sair
extern mostrar_texto

divisao32:

    push ebp                ; Salva o endereço de retorno
    mov ebp, esp            ; Passa o endereço da base
    
    ; Realiza a divisão com 32 bits
    ; ebp+8 = divisor
    ; ebp+12 = dividendo

    mov ecx, [ebp+8]       ; ecx = divisor (num2)
    
    cmp ecx, 0             ; Verifica se divisor é zero
    je divisao_por_zero
    
    mov eax, [ebp+12]      ; eax = dividendo (num1)
    
    ; Para evitar problemas com sinal, usa idiv (signed divide)
    cdq                    ; Estende o sinal de eax para edx:eax
    idiv ecx               ; edx:eax / ecx, resultado em eax, resto em edx

    jmp fim_divisao


divisao16:

    push ebp
    mov ebp, esp
    
    mov cx, [ebp+8]        ; cx = divisor (num2)
    
    cmp cx, 0              ; Verifica se divisor é zero
    je divisao_por_zero
    
    mov ax, [ebp+12]       ; ax = dividendo (num1)
    
    ; Para divisão com sinal em 16 bits
    cwd                    ; Estende o sinal de ax para dx:ax
    idiv cx                ; dx:ax / cx, resultado em ax, resto em dx
    
    movsx eax, ax          ; Estende ax para eax

fim_divisao:

    mov esp, ebp
    pop ebp                ; Recupera a posição de retorno da stack

    ret                    ; eax = resultado da divisão

divisao_por_zero:

    ; Mostrar que ocorreu divisão por zero
    push dword tam_texto_divisao_zero
    push dword texto_divisao_zero
    call mostrar_texto
    add esp, 8
    
    call sair
