; Escreva um programa que implemente a seguinte sentença da linguagem Java:
; a = b + c + 100;
; As variáveis a, b e c são valores inteiros armazenados na memória. 
; O conteúdo das variáveis b e c deverão ser inicializados com valores definidos por você.

.686
.model flat, stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\msvcrt.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\msvcrt.lib
include \masm32\macros\macros.asm

.data ; Seção de dados, na qual as variáveis são declaradas e inicializadas
    var_b dd 10 ; Variável 'var_b' do tipo double word (4B) inicializada com 10
    var_c dd 5 ; Variável 'var_c' do tipo double word (4B) inicializada com 5
    var_a dd ? ; Variável 'var-a' do tipo double word (4B) sem inicialização

.code ; Seção de código onde ficam as instruções executáveis
; Rótulo que marca o ponto de entrada do programa
start:
    ; Carrega os valores de 'b' e 'c' e realiza a operação
    mov eax, var_b ; Carrega o valor de 'b' no registrador eax
    add eax, var_c ; Adiciona o valor de 'c' ao registrador eax
    add eax, 100 ; Soma 100 ao valor do registrador eax
    mov var_a, eax ; Armazena o resultado em 'a'

    printf("Valor do somatorio: %d + %d + 100 = %d\n", var_b, var_c, var_a) ; Exibe o valor calculado
   
    invoke ExitProcess, 0 ; Finaliza o programa

end start ; Fim do código principal, marca o término da função start e do programa