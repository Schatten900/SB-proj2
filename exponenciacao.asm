section .data

texto_overflow db "OCORREU OVERFLOW",10
tam_texto_overflow equ $- texto_overflow 


texto_expoente_negativo db "EXPOENTE NEGATIVO",10
tam_texto_expoente_negativo equ $- texto_expoente_negativo 

section .text


global exponenciacao
extern ler_int16
extern ler_int32
extern mostrar_texto


exponenciacao:

    push ebp    ; Salva o endereço de retorno

    mov ebp, esp   ; Passa o valor do topo da pilha pra base

    mov ecx, [ebp+8]    ; Passa o valor de precisao

    cmp byte[ecx], '0'
    je exponenciacao_16

    ; Realiza a exponenciacao de 32 bits

    ; ideia de algoritimo pegar numero(base) e o expoente
    ; loop para decrementar expoente ate que seja 0 
    ; Para cada iteracao multiplicar o resultado atual pelo valor base, logo eax = resultado * anterior * qntd vezes
    ; Pode-se pensar em armazenar o valor atual do topo da pilha pelo valor base pego (pode estar em esi) e o expoente em ebx 

    call ler_int32
    push eax        ; salva eax = base na pilha

    call ler_int32  
    mov esi, eax    ; esi = expoente

    cmp esi,0       ; Verifica expoente negativo
    jl expoente_negativo_32

    cmp esi,0       ; Se o expoente for 0, retornar o valor 1
    je expoente_zero_32

    pop eax         ; recupera o valor de eax
    mov ebx,eax     ; passa o valor da base para ebx

    dec esi         ; A fim de evitar multiplicacao a mais


loop_exponenciacao_32:

    cmp esi,0
    je fim_exponenciaccao
    
    imul ebx    ; eax * ebx -> atual * base 
    jo overflow ; verifica overflow
    dec esi     ; expoente -= 1

    jmp loop_exponenciacao_32


;=======================
;   Operacao com 16
;=======================

exponenciacao_16:


    call ler_int16          ; eax = valor lido
    push eax                ; Salva o valor da base eax na pilha

    call ler_int16          ; eax = expoente lido
    mov esi, eax            ; esi = expoente lido


    cmp esi,0               ; Verifica expoente negativo
    jl expoente_negativo_16

    cmp esi,0               ; Se o expoente for 0, retornar o valor 1
    je expoente_zero_16

    pop eax                 ; recupera valor da base

    mov bx,ax               ; passa a base para ebx

    dec esi                 ; A fim de evitar multiplicacao a mais
    

loop_exponenciacao_16:

    cmp esi,0           ; Verifica se o expoente ja é 0
    je sair_loop_16

    imul bx        ; atual * base
    jo overflow    ; verifica overflow
    dec esi        ; expoente -= 1

    jmp loop_exponenciacao_16


sair_loop_16:

    movsx eax,ax   ; passa o valor de ax para eax


fim_exponenciaccao:

    ; Faz a descarga do endereço de retorno
    mov esp,ebp
    pop ebp

    ret



;========================
;   Tratamento de erros
;========================


expoente_negativo_32:
    pop eax      ; remove a base empilhada
    jmp erro

expoente_zero_32:
    pop eax      ; remove a base empilhada
    mov eax,1    ; Passa 1 para resposta
    jmp fim_exponenciaccao

expoente_negativo_16:
    pop eax      ; remove a base empilhada
    jmp erro

expoente_zero_16:
    pop eax      ; remove a base empilhada
    mov eax,1    ; Passa 1 para resposta
    jmp fim_exponenciaccao

erro:

    push dword tam_texto_expoente_negativo
    push dword texto_expoente_negativo
    call mostrar_texto
    add esp, 8 

    jmp sair


overflow:

    push dword tam_texto_overflow
    push dword texto_overflow
    call mostrar_texto
    add esp, 8      ; Desempilha os dados

    jmp sair