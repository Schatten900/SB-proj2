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
precisao_usuario: resb 2
menu_opcao: resb 2


section .text

; ==================
; Imports
; ==================
global _start
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

    ; Pega o nome do usuario

    push dword 64
    push dword nome_usuario
    call ler_string     ; Resultado estará em EAX
    add esp, 8
    dec eax             ; ignora o '\n'


boas_vindas:
    ; Funcao responsavel por printar boas vindas ao usuario
    push dword tam_texto_hola
    push dword texto_hola
    call mostrar_texto
    add esp, 8  ; Desempilha os dados

    push dword nome_usuario
    push dword 
    call mostrar_texto
    add esp, 8

    push dword tam_texto_boas_vindas 
    push dword texto_nome_usuario
    call mostrar_texto
    add esp,8


escolher_precisao:
    ; Funcao responsavel por perguntar qual a precisao a ser utilizada



loop_menu:
    ; Loop do menu ate o usuario digitar 7

    


mostrar_menu:
    ; Funcao responsavel por mostrar as opcoes do menu



ler_string:
    ; Funcao responsavel pela leitura de string
    push ebp
    mov ebp, esp

    mov ecx [ebp+8]     ; Pega o tamanho da variavel a ser guardada
    mov edx [ebp+12]    ; Pega a variavel a ser guardada o valor
    mov eax, 3
    mov ebx, 0
    EXECUTAR_SYSCALL

    pop ebp
    ret                 ; EAX = quantidade de bytes lidos


ler_int16:
    ; Funcao responsavel pelo int 16



ler_int32:
    ; Funcao responsavel pelo int 32



mostrar_texto:
    ; Recebe pela pilha o ponteiro da variavel global de texto e a quantidade de bytes

    push ebp
    mov ebp, esp        ; EBP antigo, onde EBP+4 é o endereço de retorno

    mov ecx, [ebp+8]    ; Pega o texto 
    mov edx, [ebp+12]   ; Pega o tamanho do texto

    mov eax, 4          ; Syscall de print
    mov ebx, 1
    EXECUTAR_SYSCALL
    ret


sair:
    mov EAX, 1
    mov EBX, 1
    EXECUTAR_SYSCALL
    