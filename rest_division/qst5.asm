; Escreva um programa que exiba na console os números entre 1000 e 1999 que divididos por 11
; dão resto 5.

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
    printf("Numeros entre 1000 e 1999 que divididos por 11 tem resto 5: \n")
    mov ecx, 1000 ; Inicializa o registrador ECX (será utilizado como contador)
    xor edx, edx ; Zera o registrador EDX (será utilizado como resto da divisão)

loop_start:
    mov eax, ecx ; Copia o valor do contador para o registrador EAX
    mov ebx, 11 ; Definição do divisor como 11
    div ebx ; Divide EAX por EBX, quociente em EAX, resto em EDX
    cmp edx, 5 ; Verifica se o resto da divisão é 5
    jne next_number ; Se o resto não for 5, pula para o próximo número
    printf("%d\n", ecx)
    
next_number:
    inc ecx ; Incrementa o contador
    cmp ecx, 1999 ; Verifica se ecx não ultrapassou 1999
    jl loop_start ; Se ECX < 2000, continua o loop

    invoke ExitProcess, 0 ; Finaliza o programa

end start