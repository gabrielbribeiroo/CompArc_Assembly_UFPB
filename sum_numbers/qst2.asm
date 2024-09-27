; Escreva um programa que implemente a seguinte linha da linguagem Java:
; a = b + c + 100;
; Variaveis a, b e c: valores inteiros armazenados na memoria. 
; O conteudo das variaveis b e c devem ser inicializados com valores definidos pelo programador.

.686
.model flat, stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\msvcrt.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\msvcrt.lib
include \masm32\macros\macros.asm

.data ; Secao de dados, na qual as variaveis sao declaradas e inicializadas
    var_b dd 10 ; Variavel 'var_b' do tipo double word (4B) inicializada com 10
    var_c dd 5 ; Variavel 'var_c' do tipo double word (4B) inicializada com 5
    var_a dd ? ; Variavel 'var-a' do tipo double word (4B) sem inicializar

.code ; Secao de codigo onde ficam as instrucoes executaveis
; Rotulo que marca o ponto de entrada do programa
start:
    ; Carrega os valores de 'b' e 'c' e realiza a operacao
    mov eax, var_b ; Carrega o valor de 'b' no registrador EAX
    add eax, var_c ; Adiciona o valor de 'c' ao registrador EAX
    add eax, 100 ; Soma 100 ao valor do registrador EAX
    mov var_a, eax ; Armazena o resultado em 'a'

    printf("Valor do somatorio: %d + %d + 100 = %d\n", var_b, var_c, var_a) ; Exibe o valor calculado
   
    invoke ExitProcess, 0 ; Finaliza o programa

end start ; Fim do codigo principal, marca o encerramento da funcao start do programa