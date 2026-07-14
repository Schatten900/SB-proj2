section .data

texto_erro_mod db "ERRO: MOD POR ZERO",10
tam_texto_erro_mod equ $- texto_erro_mod

section .text

global mod32
global mod16
extern sair
extern mostrar_texto

mod32:

    push ebp             ; Salva o endereço de retorno
    mov ebp, esp         ; Passa o endereço da base
    ; Realiza a operação mod com 32 bits

    mov ecx, [ebp+8]     ; ecx = divisor (num2)
    cmp ecx, 0
    je erro_mod          ; Se divisor for 0, erro
    
    mov eax, [ebp+12]    ; eax = dividendo (num1)
    cdq                  ; Estende EAX para EDX:EAX (para divisão com sinal)
    idiv ecx             ; EDX:EAX / ECX, resultado em EAX, resto em EDX
    mov eax, edx         ; Coloca o resto em EAX

    jmp fim_mod


mod16:

    push ebp
    mov ebp, esp

    mov cx, [ebp+8]      ; cx = divisor (num2)
    cmp cx, 0
    je erro_mod          ; Se divisor for 0, erro
    
    mov ax, [ebp+12]     ; ax = dividendo (num1)
    cwd                  ; Estende AX para DX:AX (para divisão com sinal)
    idiv cx              ; DX:AX / CX, resultado em AX, resto em DX
    mov ax, dx           ; Coloca o resto em AX

    movsx eax, ax        ; copia um valor menor (de 8 ou 16 bits) para um registrador maior (de 16, 32 ou 64 bits)

fim_mod:
    
    mov esp, ebp
    pop ebp              ; Recupera a posicao de retorno da stack

    ret                  ; eax = valor do módulo

erro_mod:

    ; Mostrar erro de mod por zero
    push dword tam_texto_erro_mod
    push dword texto_erro_mod
    call mostrar_texto
    add esp, 8

    call sair
