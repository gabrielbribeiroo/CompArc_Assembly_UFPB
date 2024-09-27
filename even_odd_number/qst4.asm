; Escreva um programa que leia uma constante numerica inteira e, em seguida, escreva na tela a paridade
; do numero.

.686
.model flat, stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\msvcrt.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\msvcrt.lib

.data
    msg_par db "O numero eh par!", 0Ah, 0H
    msg_impar db "O numero eh impar!", 0Ah, 0H
    num dd 5 ; Constante numerica

.code
start:
    ; Verifica a paridade do numero
    mov eax, [num] ; Carrega 'num' no registrador EAX
    and eax, 1 ; Faz um AND bit a bit de EAX com 1. Se o resultado for 0, o numero eh par
    cmp eax, 0 
    je par ; Se o bit menos significativo for 0, salta para 'par'

    ; Numero impar
    invoke crt_printf, addr msg_impar ; Exibe a mensagem de numero impar
    jmp fim ; Pula para o final

par:
    ; Numero par
    invoke crt_printf, addr msg_par ; Exibe a mensagem de numero par

fim:
    ; Finaliza o programa
    invoke ExitProcess, 0

end start