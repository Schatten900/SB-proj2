%define EXECUTAR_SYSCALL int 0x80

section .data

;=====================
;   Bem vindo
;=====================

texto_boas_vindas db "Bem-vindo. Digite seu nome:",10
tam_texto_boas_vindas equ $ - texto_boas_vindas

texto_hola db "Hola, "
tam_texto_hola equ $ - texto_hola

texto_nome_usuario db " bem-vindo ao programa de CALC IA-32",10
tam_texto_nome_usuario equ $ - texto_nome_usuario

texto_precisao db "Vai trabalhar com 16 ou 32 bits (digite 0 para 16, e 1 para 32):",10
tam_texto_precisao equ $ - texto_precisao


;=====================
;   Menu
;=====================

texto_menu0 db "ESCOLHA UMA OPÇÃO:",10
tam_texto_menu0 equ $ - texto_menu0

texto_menu1 db "- 1: SOMA",10
tam_texto_menu1 equ $ - texto_menu1

texto_menu2 db "- 2: SUBTRACAO",10
tam_texto_menu2 equ $ - texto_menu2

texto_menu3 db "- 3: MULTIPLICACAO",10
tam_texto_menu3 equ $ - texto_menu3

texto_menu4 db "- 4: DIVISAO",10
tam_texto_menu4 equ $ - texto_menu4

texto_menu5 db "- 5: EXPONENCIACAO",10
tam_texto_menu5 equ $ - texto_menu5

texto_menu6 db "- 6: MOD",10
tam_texto_menu6 equ $ - texto_menu6

texto_menu7 db "- 7: SAIR",10
tam_texto_menu7 equ $ - texto_menu7

nova_linha db 10


section .bss

;=====================
;  Variaveis globais
;=====================

nome_usuario: resb 64
tam_nome_usuario: resd 1
precisao_usuario: resb 2
menu_opcao: resb 2
buffer_conv: resb 32    ; Buffer seguro para conversão de números para string
buffer_enter: resb 1

section .text

; ==================
; Globals
; ==================
global _start
global mostrar_texto
global ler_string
global ler_int16
global ler_int32
global converter_int16_para_str
global converter_int32_para_str
global converter_str_para_int_16
global converter_str_para_int_32
global sair

; ==================
; Imports
; ==================
extern soma16
extern soma32
extern multi16
extern multi32
extern exponenciacao16
extern exponenciacao32
extern subtracao16
extern subtracao32
extern divisao16
extern divisao32
extern mod16
extern mod32

; ==================
; Função principal
; ==================
_start:

    ; Funcao responsavel pela chamada de todas as outras funcoes
    call pegar_nome
    call boas_vindas
    call escolher_precisao
    call loop_menu


pegar_nome:
    ; Funcao responsavel por pegar o nome do usuario
    push dword tam_texto_boas_vindas
    push dword texto_boas_vindas
    call mostrar_texto
    add esp, 8  ; Desempilha os dados

    ; Pega o nome do usuario (Input)
    push dword 64
    push dword nome_usuario
    call ler_string     ; Resultado estará no nome_usuario e a quantidade de bytes lidos em EAX
    add esp, 8          ; Desempilha 
    dec eax             ; Ignora o '\n'
    mov byte [nome_usuario + eax], 0 ; Para retirar o '\n' da str e colocar o '\0' 
    mov [tam_nome_usuario], eax        ; tamanho do nome
    
    ret


boas_vindas:
    ; Funcao responsavel por printar boas vindas ao usuario

    ; Hola
    push dword tam_texto_hola
    push dword texto_hola
    call mostrar_texto
    add esp, 8  ; Desempilha os dados

    ; Nome de usuario
    push dword [tam_nome_usuario]               
    push dword nome_usuario
    call mostrar_texto
    add esp, 8  ; Desempilha os dados

    ; Boas vindas
    push dword tam_texto_nome_usuario 
    push dword texto_nome_usuario
    call mostrar_texto
    add esp,8  ; Desempilha os dados

    ret 


escolher_precisao:
    ; Funcao responsavel por perguntar qual a precisao a ser utilizada

    push dword tam_texto_precisao
    push dword texto_precisao
    call mostrar_texto
    add esp, 8

    ; Coloca a precisao dentro da variavel
    push dword 2
    push dword precisao_usuario
    call ler_string
    add esp, 8      ; desempilha
    dec eax         ; ignora '\n'
    
    ret 


loop_menu:
    ; Loop do menu ate o usuario digitar 7

    call mostrar_menu

    ; Leitura do valor do menu
    push dword 2
    push dword menu_opcao
    call ler_string
    add esp, 8      ; desempilha
    dec eax         ; ignora '\n'

    ; Escolha da opcao
    cmp byte [menu_opcao], '1' 
    je opcao_soma
    
    cmp byte [menu_opcao], '2'
    je opcao_subtracao

    cmp byte [menu_opcao], '3'
    je opcao_mult

    cmp byte [menu_opcao], '4'
    je opcao_divisao

    cmp byte [menu_opcao], '5'
    je opcao_exponenciacao

    cmp byte [menu_opcao], '6'
    je opcao_mod

    cmp byte [menu_opcao], '7'
    je sair

    jmp loop_menu


;==========================
;   Opcoes
;==========================

opcao_soma:
    cmp byte[precisao_usuario],'0'
    je opcao_soma16

    call ler_int32
    push eax        ; salva primeiro valor

    call ler_int32  
    push eax        ; salva segundo valor

    call soma32       ; eax = resultado da soma
    add esp,8

    call mostrar_resultado
    jmp loop_menu

opcao_soma16:
    call ler_int16
    push eax            ; salva num1

    call ler_int16
    push eax            ; salva num2

    call soma16         ; eax = resultado da soma
    add esp,8

    call mostrar_resultado
    jmp loop_menu


opcao_subtracao:
    cmp byte[precisao_usuario],'0'
    je opcao_subtracao16

    call ler_int32
    push eax        ; num1

    call ler_int32
    push eax        ; num2

    call subtracao32      ; eax = resultado da subtracao
    add esp,8

    call mostrar_resultado
    jmp loop_menu

opcao_subtracao16:
    call ler_int16
    push eax        ; num1

    call ler_int16
    push eax        ; num2

    call subtracao16    ; eax = resultado da subtracao
    add esp,8

    call mostrar_resultado
    jmp loop_menu


opcao_mult:
    cmp byte[precisao_usuario],'0'
    je opcao_mult16

    call ler_int32
    push eax        ; num1

    call ler_int32
    push eax        ; num2

    call multi32      ; eax = resultado da multiplicacao
    add esp,8

    call mostrar_resultado
    jmp loop_menu

opcao_mult16:
    call ler_int16
    push eax        ; num1

    call ler_int16
    push eax        ; num2

    call multi16    ; eax = resultado da multiplicacao
    add esp,8

    call mostrar_resultado
    jmp loop_menu


opcao_divisao:
    cmp byte[precisao_usuario],'0'
    je opcao_divisao16

    call ler_int32
    push eax        ; num1

    call ler_int32
    push eax        ; num2

    call divisao32      ; eax = resultado da divisao
    add esp,8

    call mostrar_resultado
    jmp loop_menu

opcao_divisao16:
    call ler_int16
    push eax        ; num1

    call ler_int16
    push eax        ; num2

    call divisao16    ; eax = resultado da divisao
    add esp,8

    call mostrar_resultado
    jmp loop_menu


opcao_mod:
    cmp byte[precisao_usuario],'0'
    je opcao_mod16

    call ler_int32
    push eax        ; num1

    call ler_int32
    push eax        ; num2

    call mod32      ; eax = resultado do mod
    add esp,8

    call mostrar_resultado
    jmp loop_menu

opcao_mod16:
    call ler_int16
    push eax        ; num1

    call ler_int16
    push eax        ; num2

    call mod16    ; eax = resultado do mod
    add esp,8

    call mostrar_resultado
    jmp loop_menu


opcao_exponenciacao:
    cmp byte[precisao_usuario], '0'
    je opcao_exponenciacao_16

    call ler_int32
    push eax            ; salva a base

    call ler_int32      
    push eax            ; salva o expoente

    call exponenciacao32  ; eax = resultado da exponenciacao
    add esp,8

    call mostrar_resultado
    jmp loop_menu

opcao_exponenciacao_16:
    call ler_int16
    push eax            ; salva a base

    call ler_int16      
    push eax            ; salva o expoente

    call exponenciacao16
    add esp, 8

    call mostrar_resultado
    jmp loop_menu


    
;==========================
;   Input/Output
;==========================

mostrar_resultado:
    ; Resultado está contido em EAX, converte para string e mostra de forma limpa.
    push ebp
    mov ebp, esp
    push edi
    push ecx

    ; Converte o valor numérico em EAX para string no buffer estático
    push eax                
    call converter_int32_para_str 
    add esp, 4              ; EAX agora contém o ponteiro "buffer_conv"

    ; Conta o tamanho da string resultante (strlen manual)
    mov edi, eax            ; EDI aponta para o início da string
    mov ecx, 0              ; Contador de tamanho
.contar_loop:
    cmp byte [edi + ecx], 0
    je .contar_fim
    inc ecx
    jmp .contar_loop
.contar_fim:

    ; mostrar_texto espera: [ebp+12] = tamanho (ecx), [ebp+8] = ponteiro (eax)
    push ecx                ; tamanho (pushed primeiro -> [ebp+12])
    push eax                ; ponteiro (pushed segundo -> [ebp+8])
    call mostrar_texto
    add esp, 8

    ; Imprime uma nova linha após o resultado para fins estéticos
    push dword 1
    push dword nova_linha
    call mostrar_texto
    add esp, 8

    pop ecx
    pop edi

    ; Espera o ENTER do usuário
    push dword 1
    push dword buffer_enter
    call ler_string
    add esp, 8


    mov esp, ebp
    pop ebp

    ret 

mostrar_menu:
    push dword tam_texto_menu0
    push dword texto_menu0
    call mostrar_texto
    add esp, 8

    push dword tam_texto_menu1
    push dword texto_menu1
    call mostrar_texto
    add esp, 8

    push dword tam_texto_menu2
    push dword texto_menu2
    call mostrar_texto
    add esp, 8

    push dword tam_texto_menu3
    push dword texto_menu3
    call mostrar_texto
    add esp, 8

    push dword tam_texto_menu4
    push dword texto_menu4
    call mostrar_texto
    add esp, 8

    push dword tam_texto_menu5
    push dword texto_menu5
    call mostrar_texto
    add esp, 8

    push dword tam_texto_menu6
    push dword texto_menu6
    call mostrar_texto
    add esp, 8

    push dword tam_texto_menu7
    push dword texto_menu7
    call mostrar_texto
    add esp, 8

    ret 

ler_string:
    push ebp             
    mov ebp, esp         

    mov ecx, [ebp+8]     ; Endereço do buffer
    mov edx, [ebp+12]    ; Tamanho máximo
    mov eax, 3           ; Syscall sys_read
    mov ebx, 0           ; stdin
    EXECUTAR_SYSCALL

    mov esp, ebp
    pop ebp             
    ret                 


ler_int16:
    push ebp            
    mov ebp, esp        

    sub esp, 16         
    lea eax, [ebp-16]   

    push dword 16       
    push eax            
    call ler_string     
    add esp, 8

    lea eax, [ebp-16]   
    push eax
    call converter_str_para_int_16 
    add esp, 4           

    mov esp, ebp
    pop ebp             
    ret                 


ler_int32:
    push ebp            
    mov ebp, esp        

    sub esp, 32         
    lea eax, [ebp-32]

    push dword 32       
    push eax            
    call ler_string     
    add esp, 8

    lea eax, [ebp-32]   
    push eax
    call converter_str_para_int_32  
    add esp, 4           

    mov esp, ebp 
    pop ebp             
    ret                 

mostrar_texto:
    push ebp            
    mov ebp, esp        

    mov ecx, [ebp+8]    ; Endereço do texto
    mov edx, [ebp+12]   ; Tamanho do texto

    mov eax, 4          ; Syscall sys_write
    mov ebx, 1          ; stdout
    EXECUTAR_SYSCALL

    mov esp, ebp
    pop ebp             
    ret


;==========================
;   Conversoes
;==========================

converter_int16_para_str:
    push ebp
    mov ebp, esp
    push ebx            
    push edi
    push esi
    
    mov ax, [ebp+8]     
    movsx eax, ax       
    mov edi, buffer_conv; Usa o buffer global seguro
    mov ebx, 10         
    
    ; Verificar se é negativo
    cmp eax, 0
    jge converter_int16_positivo
    
    mov byte [edi], '-' 
    inc edi             
    neg eax             
    
converter_int16_positivo:
    mov ecx, 0          
    lea esi, [edi+10]   
    mov byte [esi], 0   
    
converter_int16_para_str_loop:
    mov edx, 0
    div ebx             
    add dl, '0'         
    dec esi             
    mov byte [esi], dl  
    inc ecx             
    cmp eax, 0
    jne converter_int16_para_str_loop
    
    ; --- Cópia dos dígitos gerados ---
.copy_loop_16:
    mov al, [esi]
    mov [edi], al       
    inc esi
    inc edi
    dec ecx
    jnz .copy_loop_16
    
    mov byte [edi], 0   
    
converter_int16_para_str_fim:
    mov eax, buffer_conv
    pop esi             
    pop edi
    pop ebx
    mov esp, ebp
    pop ebp
    ret 

;==============================================================================================

converter_int32_para_str:
    push ebp
    mov ebp, esp
    push ebx            
    push edi
    push esi
    
    mov eax, [ebp+8]    
    mov edi, buffer_conv; Usa o buffer global seguro
    mov ebx, 10         
    
    ; Verificar se é negativo
    cmp eax, 0
    jge converter_int32_positivo
    
    mov byte [edi], '-' 
    inc edi             
    neg eax             
    
converter_int32_positivo:
    mov ecx, 0          
    lea esi, [edi+20]   
    mov byte [esi], 0   
    
converter_int32_para_str_loop:
    mov edx, 0
    div ebx             
    add dl, '0'         
    dec esi             
    mov byte [esi], dl  
    inc ecx             
    cmp eax, 0
    jne converter_int32_para_str_loop
    
    ; --- Cópia dos dígitos gerados ---
.copy_loop_32:
    mov al, [esi]
    mov [edi], al       
    inc esi
    inc edi
    dec ecx
    jnz .copy_loop_32
    
    mov byte [edi], 0   
    
converter_int32_para_str_fim:
    mov eax, buffer_conv
    pop esi             
    pop edi
    pop ebx
    mov esp, ebp
    pop ebp
    ret 

;==============================================================================================

converter_str_para_int_16:
    push ebp
    mov ebp, esp
    push esi            
    
    mov esi, [ebp+8]    
    mov eax, 0          
    mov ecx, 1          
    
    ; Verificar se é negativo
    cmp byte [esi], '-'
    jne converter_str_para_int_loop_16
    mov ecx, -1
    inc esi
    
converter_str_para_int_loop_16:
    movzx edx, byte [esi]  
    cmp dl, 0              
    je converter_str_para_int_fim_16
    cmp dl, 10             
    je converter_str_para_int_fim_16
    cmp dl, 13             
    je converter_str_para_int_fim_16
    
    ; Converter ASCII para dígito
    sub dl, '0'
    imul eax, eax, 10   
    add eax, edx        
    
    inc esi
    jmp converter_str_para_int_loop_16
    
converter_str_para_int_fim_16:
    imul eax, ecx       
    movsx eax, ax       
    
    pop esi             
    mov esp, ebp
    pop ebp
    ret 

;==============================================================================================

converter_str_para_int_32:
    push ebp
    mov ebp, esp
    push esi            
    
    mov esi, [ebp+8]    
    mov eax, 0          
    mov ecx, 1          
    
    ; Verificar se é negativo
    cmp byte [esi], '-'
    jne converter_str_para_int_loop_32
    mov ecx, -1
    inc esi
    
converter_str_para_int_loop_32:
    movzx edx, byte [esi]  
    cmp dl, 0              
    je converter_str_para_int_fim_32
    cmp dl, 10             
    je converter_str_para_int_fim_32
    cmp dl, 13             
    je converter_str_para_int_fim_32
    
    ; Converter ASCII para dígito
    sub dl, '0'
    imul eax, eax, 10   
    add eax, edx        
    
    inc esi
    jmp converter_str_para_int_loop_32
    
converter_str_para_int_fim_32:
    imul eax, ecx       
    
    pop esi             
    mov esp, ebp
    pop ebp
    ret 

;==========================
;   Exit
;==========================

sair:
    mov EAX, 1
    mov EBX, 0          ; Retorno zero (sucesso)
    EXECUTAR_SYSCALL