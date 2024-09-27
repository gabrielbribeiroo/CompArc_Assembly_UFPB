; Escreva um programa que calcule a soma dos 100 primeiros números inteiros positivos.
; O resultado deverá ser armazenado no registrador eax e também deverá ser exibido na tela.

.686
.model flat, stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\msvcrt.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\msvcrt.lib
include \masm32\macros\macros.asm

.code
start:
    ; Inicializa os registradores
    xor eax, eax ; Zera o registrador EAX (será utilizado para soma)
    mov ecx, 1 ; Inicializa o registrador ECX (será utilizado como contador)

soma_loop:
    add eax, ecx ; Soma o valor de ecx a eax
    inc ecx ; Incrementa o contador
    cmp ecx, 100 ; Verifica se ecx chegou a 100
    jle soma_loop ; Se ecx <= 100, continua o loop

    printf("Soma dos 100 primeiros numeros: %d\n", eax) ; Exibe o valor de eax na tela

    invoke ExitProcess, 0 ; Finaliza o programa

end start
