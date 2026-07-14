section .data

texto_divisao_zero db "ERRO: Modulo por zero",10
tam_texto_divisao_zero equ $- texto_divisao_zero

section .text

global mod32
global mod16
extern sair
extern mostrar_texto

mod32:

    push ebp                ; Salva o endereço de retorno
    mov ebp, esp            ; Passa o endereço da base
    
    ; Realiza o módulo com 32 bits
    ; ebp+8 = divisor (num2)
    ; ebp+12 = dividendo (num1)

    mov ecx, [ebp+8]       ; ecx = divisor
    
    cmp ecx, 0             ; Verifica se divisor é zero
    je divisao_por_zero
    
    mov eax, [ebp+12]      ; eax = dividendo
    
    ; Para operação com sinal
    cdq                    ; Estende o sinal de eax para edx:eax
    idiv ecx               ; edx:eax / ecx, resultado em eax, resto em edx
    
    mov eax, edx           ; Move o resto para eax

    jmp fim_mod


mod16:

    push ebp
    mov ebp, esp
    
    mov cx, [ebp+8]        ; cx = divisor
    
    cmp cx, 0              ; Verifica se divisor é zero
    je divisao_por_zero
    
    mov ax, [ebp+12]       ; ax = dividendo
    
    ; Para operação com sinal em 16 bits
    cwd                    ; Estende o sinal de ax para dx:ax
    idiv cx                ; dx:ax / cx, resultado em ax, resto em dx
    
    mov ax, dx             ; Move o resto para ax
    movsx eax, ax          ; Estende ax para eax

fim_mod:

    mov esp, ebp
    pop ebp                ; Recupera a posição de retorno da stack

    ret                    ; eax = resultado do módulo

divisao_por_zero:

    ; Mostrar que ocorreu modulo por zero
    push dword tam_texto_divisao_zero
    push dword texto_divisao_zero
    call mostrar_texto
    add esp, 8
    
    call sair
