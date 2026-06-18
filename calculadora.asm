%define EXECUTAR_SYSCALL int 0x80

section .data

;=====================
;   Bem vindo
;=====================

texto_boas_vindas db "Bem-vindo. Digite seu nome:",10
tam_texto_boas_vindas equ $ - texto_boas_vindas

texto_hola db "Hola, ",10
tam_texto_hola equ $ - texto_hola

texto_nome_usuario db "bem-vindo ao programa de CALC IA-32",10
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


section .bss

;=====================
;  Variaveis globais
;=====================

nome_usuario: resb 64
tam_nome_usuario: resd 1
precisao_usuario: resb 2
menu_opcao: resb 2


section .text

; ==================
; Imports
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


extern soma
extern multi
extern exponenciacao

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
    
    cmp byte [menu_opcao], '3'
    je opcao_mult

    cmp byte [menu_opcao], '5'
    je opcao_exponenciacao

    cmp byte [menu_opcao], '7'
    je sair

    jmp loop_menu



;==========================
;   Opcoes
;==========================

opcao_soma:
    call soma
    jmp loop_menu

opcao_mult:
    call multi
    jmp loop_menu

opcao_exponenciacao:
    call exponenciacao
    jmp loop_menu


    
;==========================
;   Input/Output
;==========================

mostrar_menu:
    ; Funcao responsavel por mostrar as opcoes do menu
    
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
    ; Funcao responsavel pela leitura de string
    push ebp             ; Salva a posicao de retorno da stack
    mov ebp, esp         ; Passa o endereço da base

    mov ecx, [ebp+8]     ; Pega a variavel a ser guardada o valor
    mov edx, [ebp+12]    ; Pega o tamanho da variavel a ser guardada
    mov eax, 3           ; Syscall de leitura de teclado
    mov ebx, 0           ; Teclado
    EXECUTAR_SYSCALL

    mov esp, ebp
    pop ebp             ; Recupera a posicao de retorno da stack
    ret                 ; EAX = quantidade de bytes lidos


ler_int16:
    ; Funcao responsavel pelo int 16

    push ebp            ; Salva a posicao de retorno da stack
    mov ebp, esp        ; Passa o valor da base 

    sub esp, 16         ; Abre espaço de 16 bytes
    lea eax, [ebp-16]   ; Passa o endereço para eax

    push dword 16       ; Armazena 16 bits
    push eax            ; Usa o registrador de 16 bits AX
    call ler_string     ; EAX = qntd de bytes lidos e no [ebp-16] ta salvo o str lido
    add esp, 8

    lea eax, [ebp-16]   ; passa o str salvo em [ebp-16] pro eax
    push eax
    call converter_str_para_int_16 ; converte o valor str em int16
    add esp,4           ; Desempilha

    mov esp, ebp
    pop ebp             ; Recupera a posicao de retorno da stack
    ret                 ; EAX = inteiro convertido


ler_int32:
    ; Funcao responsavel pelo int 32   

    push ebp            ; Salva a posicao de retorno da stack
    mov ebp, esp        ; Passa o valor da base 

    sub esp, 32         ; Abre espaço de 32 bytes
    lea eax, [ebp-32]

    push dword 32       ; Armazena 32 bits
    push eax            ; Usa o registrador de 32 bits EAX 
    call ler_string     ; [ebp-32] contem o str e eax = qntd de bytes
    add esp, 8

    lea eax, [ebp-32]   ; passa o str salvo para eax
    push eax
    call converter_str_para_int_32  ; converte o valor str em int32
    add esp,4           ; desempilha

    mov esp, ebp 
    pop ebp             ; Recupera o valor da posicao de retorno da stack
    ret                 ; EAX = inteiro convertido

mostrar_texto:
    ; Recebe pela pilha o ponteiro da variavel global de texto e a quantidade de bytes

    push ebp            ; Salva a posicao de retorno da stack
    mov ebp, esp        ; Passa o valor da base 

    mov ecx, [ebp+8]    ; Pega o texto 
    mov edx, [ebp+12]   ; Pega o tamanho do texto

    mov eax, 4          ; Syscall de print
    mov ebx, 1          ; Syscall do monitor
    EXECUTAR_SYSCALL

    mov esp, ebp
    pop ebp             ; Recupera a posicao de retorno da stack
    ret


;==========================
;   Conversoes
;==========================

converter_int16_para_str:
    ; Realiza a conversão do int16 para str para mostrar ao usuario



converter_int16_para_str_loop:



converter_int16_para_str_fim:
    ret 

;==============================================================================================

converter_int32_para_str:
    ; Realiza a conversão do int para str para mostrar ao usuario



converter_int32_para_str_loop:



converter_int32_para_str_fim:
    ret 

;==============================================================================================


converter_str_para_int_16:
    ; Realiza a conersao do str recebido para int para calculos 16 bits


converter_str_para_int_loop_16:
    
    

converter_str_para_int_fim_16:
    ret 


;==============================================================================================

converter_str_para_int_32:
    ; Realiza a conersao do str recebido para int para calculos 32 bits


converter_str_para_int_loop_32:
    
    

converter_str_para_int_fim_32:

    ret

;==============================================================================================

;==========================
;   Exit
;==========================

sair:
    mov EAX, 1
    mov EBX, 1
    EXECUTAR_SYSCALL
    