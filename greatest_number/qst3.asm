; Escreva um programa que leia duas constantes numericas inteiras e imprima o maior dentre os dois
; numeros informados. Se os valores forem iguais, o programa pode imprimir qualquer uma das
; variaveis.

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
    num1 dd 30 ; Primeira constante
    num2 dd 20 ; Segunda constante

.code
start:
    ; if (num1 > num2) {printf("%d", num1);} else {printf("%d", num2);}
    ; Carrega os valores de num1 e num2 nos registradores EAX e EBX
    mov eax, num1 ; Carrega num1 em EAX

    ; Compara os dois valores
    cmp eax, num2 ; Compara EAX (num1) com EBX (num2)
    jge print_eax ; Se num1 >= num2, salta para print_eax

    ; Se num2 for maior, imprime num2
    printf("Maior valor foi o num2: %d\n", num2)
    jmp fim ; Pula para o final do programa 

print_eax:
    ; Se EAX for maior ou igual, imprime num1
    printf("Maior valor foi o num1: %d\n", eax)

fim:
    invoke ExitProcess, 0 ; Finaliza o programa

end start
