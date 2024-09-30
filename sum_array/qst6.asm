; Escreva um programa que receba um array de 10 números inteiros de dois bytes (tipo WORD) e
; que exiba o valor da soma desses 10 números.

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
    arr dw 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ; Array inicializado com 10 números (2 bytes cada)
    arr_tam dd 10 ; Variável para armazenar o tamanho do array
    sum dd 0 ; Variável para armazenar a soma final

.code 
start:
    ; Inicializa os registradores
    xor eax, eax ; Zera EAX (será usado para a soma)
    xor ecx, ecx ; Zera ECX (contador de loop)

sum_loop:
    add ax, [arr + ecx*2] ; Soma o valor de cada posição do array a AX
    inc ecx ; Incrementa o contador
    cmp ecx, 10 ; Verifica se já somou todos os 10 números
    jne sum_loop ; Se não terminou, continua o loop
    mov [sum], eax ; Move a soma final para a variável 'sum'

    printf("Soma dos 10 numeros: %d\n", [sum]) ; Exibe o resultado da soma

    invoke ExitProcess, 0 ; Finaliza o programa
    
end start
