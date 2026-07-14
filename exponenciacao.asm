section .data

section .text

global exponenciacao32
global exponenciacao16
extern mostrar_texto
extern multi16
extern multi32
extern sair


exponenciacao32:

    push ebp    ; Salva o endereço de retorno

    mov ebp, esp   ; Passa o valor do topo da pilha pra base

    ; Realiza a exponenciacao de 32 bits

    mov esi,[ebp+8]     ; esi = expoente 

    cmp esi,0           
    je expoente_zero_32 ; Se o expoente for 0, retornar o valor 1

    jl expoente_negativo32 ; Se expoente negativo depende da base pro retornor ser 0 ou 1

    mov eax,[ebp+12]    ; eax = base (sera modificado)
    mov ebx,eax         ; ebx = base

    dec esi             ; A fim de evitar multiplicacao a mais


loop_exponenciacao_32:

    cmp esi,0
    je fim_exponenciacao   
    
    push eax    ; Salva o valor atual
    push ebx    ; Salva a base 

    call multi32 ; Realiza a multiplicacao
    add esp,8   ; Desempilha os dados
    
    dec esi     ; expoente -= 1

    jmp loop_exponenciacao_32


;=======================
;   Operacao com 16
;=======================

exponenciacao16:

    push ebp
    mov ebp,esp

    mov esi,[ebp+8]         ; Passa o expoente

    cmp esi,0               ; Se o expoente for 0, retornar o valor 1
    je expoente_zero_16

    jl expoente_negativo16    ; Se o expoente for negativo depende da base

    mov ax,[ebp+12]         ; ax = base

    mov bx,ax               ; bx = base 

    dec esi                 ; A fim de evitar multiplicacao a mais


loop_exponenciacao_16:

    cmp esi,0           ; Verifica se o expoente ja é 0
    je sair_loop_16

    ; Chama a multiplicacao de 16 bits
    push ax         ; Salva o valor atual
    push bx         ; Salva a base 

    call multi16    ; Realiza a multiplicacao
    add esp,8       ; Desempilha os dados

    dec esi        ; expoente -= 1

    jmp loop_exponenciacao_16


sair_loop_16:

    movsx eax,ax   ; passa o valor de ax para eax
    jmp fim_exponenciacao



;========================
;   Expoente negativo
;========================


expoente_negativo32: 

    ; Se expoente negativo retornar 0, 
    ; Exceção somente se base for 1, onde temos duas possibilidades, base 1 expoente par -> positivo e expoente impar -> negativo
    ; esi = expoente, eax = resultado ebx = base
    mov eax,[ebp+12]    ; base
    jmp trata_base

expoente_negativo16:
    movsx eax,[ebp+12]  ; base

trata_base:

    cmp eax,1           ; if (base == 1) retornar um
    je retorno_um

    cmp eax,-1          ; if (base == -1) verificar paridade do expoente
    je retorno_menos_um

    xor eax,eax         ; Se nao for nenhum dos dois casos, entao resposta é 0 
    jmp fim_exponenciacao   


retorno_um:
    mov eax,1
    jmp fim_exponenciacao


retorno_menos_um:
    
    test esi,1      ; verifica a paridade 
    jz menos_um_par

    mov eax,-1
    jmp fim_exponenciacao


menos_um_par:
    mov eax,1
    jmp fim_exponenciacao



;======================================================

;========================
;   Tratamento de erros
;========================


expoente_zero_32:

    mov eax,1    ; Passa 1 para resposta
    jmp fim_exponenciacao


expoente_zero_16:

    mov eax,1    ; Passa 1 para resposta
    jmp fim_exponenciacao


fim_exponenciacao:

    ; Faz a descarga do endereço de retorno
    mov esp,ebp
    pop ebp

    ret