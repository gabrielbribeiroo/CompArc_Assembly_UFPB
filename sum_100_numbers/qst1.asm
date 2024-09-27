; Escreva um programa que calcule a soma dos 100 primeiros numeros inteiros positivos.
; O resultado deve ser armazenado no registrador eax e ser exibido na tela.

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
    ; int acumulador = 0;
    ; for (int i=1; i<=100; ++i) {acumulador += i;}
    ; acumulador = EAX 
    ; i = ECX
    ; Inicializa os registradores
    xor eax, eax ; Zera o registrador EAX (utilizado para soma)
    mov ecx, 1 ; Inicializa o registrador ECX (utilizado como contador)

soma_loop:
    add eax, ecx ; Soma o valor de ECX a EAX
    inc ecx ; Incrementa o contador
    cmp ecx, 100 ; Verifica se ECX chegou a 100
    jbe soma_loop ; Se ecx <= 100, continua o loop

    printf("Soma dos 100 primeiros numeros: %d\n", eax) ; Exibe o valor de eax na tela

    invoke ExitProcess, 0 ; Finaliza o programa
    
end start
