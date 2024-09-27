; Escreva um programa que leia duas constantes numéricas inteiras e imprima o maior dentre os dois
; números informados. Se os valores forem iguais, o programa pode imprimir qualquer uma das
; variáveis.

.686
.model flat, stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\msvcrt.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\msvcrt.lib
include \masm32\macros\macros.asm

.data
    num1 dd 30 ; Primeira constante numérica
    num2 dd 20 ; Segunda constante numérica

.code
start:
    ; Carrega os valores de num1 e num2 nos registradores eax e ebx
    mov eax, num1 ; Carrega num1 em eax
    mov ebx, num2 ; Carrega num2 em ebx

    ; Compara os dois valores
    cmp eax, ebx ; Compara eax (num1) com ebx (num2)
    jge print_eax ; Se eax >= ebx, salta para print_eax

print_ebx:
    ; Se ebx for maior, imprime num2
    printf("Maior valor foi o num2: %d\n", ebx)
    jmp fim ; Pula para o final do programa 

print_eax:
    ; Se eax for maior ou igual, imprime num1
    printf("Maior valor foi o num1: %d\n", eax)

fim:
    invoke ExitProcess, 0 ; Finaliza o programa

end start
