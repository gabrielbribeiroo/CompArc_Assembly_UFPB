; Redução de volume em Assembly
; Grupo:     
; Davi Alves Rodrigues - 20230102377 
; Gabriel Barbosa Ribeiro de Oliveira - 20230012814
; João Vitor Sampaio Costa - 20230089776

; Configurações para o controle de como o código será compilado e executado
.686 ; Define que o código será compilado para o conjunto de instruções do processador Intel 686 ou superior
.model flat, stdcall ; Define o modelo de memória como "flat" (endereçamento linear) e o padrão de chamada de funções como "stdcall"
option casemap:none ; Desativa a diferenciação entre maiúsculas e minúsculas nos nomes de identificadores

include \masm32\include\windows.inc ; Inclui definições de constantes, estruturas e funções da API do Windows
include \masm32\include\kernel32.inc ; Inclui definições específicas das funções (manipulação de processos e arquivos
include \masm32\include\masm32.inc ; Inclui definições e funções utilitárias para desenvolvimento em Assembly
includelib \masm32\lib\kernel32.lib ; Contém as implementações das funções da Kernel32.dll.
includelib \masm32\lib\masm32.lib ; Contém as funções utilitárias do MASM32 (manipulação de strings e entrada/saída de console)

; Seção de dados, na qual as variáveis são declaradas e inicializadas
.data
    ; Handle dos arquivos de entrada e saída
    file_handle_write dd ?
    file_handle_read dd ?
     
    ; Buffers para armazenar o conteúdo lido 16 bytes e 44 bytes              
    file_contents db 16 dup(?) 
    file_contents44 db 44 dup(?) 
    file_after_div db 16 dup(?)

    bytes_read dd ? ; Variável para armazenar a quantidade de bytes lidos
    console_count dd 0 ; Variável para armazenar caracteres escritos na console

    ; Handle de entrada e saída
    inputHandle dd 0
    outputHandle dd 0
    
    ; Mensagens para o usuario
    mensagem1 db "Arquivo de entrada: ", 0h, 0h
    mensagem2 db "Arquivo de saida: ", 0h, 0h
    mensagem3 db "Digite a constante de reducao de volume (1 a 10): ", 0h
    mensagem_novamente db "Deseja processar outro arquivo? (S/N): ", 0h

    ; Variáveis para guardar o conteúdo escrito pelo usuário
    arquivo_string1 db 50 dup(0) ; Arquivo de entrada
    arquivo_string2 db 50 dup(0) ; Arquivo de saida
    resposta db 10 dup(0)        ; Armazenar a resposta do usuário
    valor_reducao db 10 dup(0)   ; Para armazenar a entrada da constante de volume
    reduction_factor dw ?        ; Constante de redução convertida para número

; Seção de código onde ficam as instruções executáveis
.code
; Ponto de entrada do programa (início da função principal)
main:
    ; Obtém o handle da entrada padrão (console)
    invoke GetStdHandle, STD_INPUT_HANDLE
    mov inputHandle, eax

    ; Obtém o handle da saída padrão
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle, eax

iniciar_processo:
    ; Lê o nome do arquivo de entrada
    invoke WriteConsole, outputHandle, addr mensagem1, sizeof mensagem1, addr console_count, NULL
    invoke ReadConsole, inputHandle, addr arquivo_string1, sizeof arquivo_string1, addr console_count, NULL
    push offset arquivo_string1
    call remover_caracter_cr

    ; Lê o nome do arquivo de saída
    invoke WriteConsole, outputHandle, addr mensagem2, sizeof mensagem2, addr console_count, NULL
    invoke ReadConsole, inputHandle, addr arquivo_string2, sizeof arquivo_string2, addr console_count, NULL
    push offset arquivo_string2
    call remover_caracter_cr

    ; Lê a constante de redução de volume
    invoke WriteConsole, outputHandle, addr mensagem3, sizeof mensagem3, addr console_count, NULL
    invoke ReadConsole, inputHandle, addr valor_reducao, sizeof valor_reducao, addr console_count, NULL
    push offset valor_reducao
    call remover_caracter_cr
    invoke atodw, addr valor_reducao
    mov reduction_factor, ax

    ; Abrir o arquivo de entrada para leitura
    invoke CreateFile, offset arquivo_string1 , GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL
    mov file_handle_read, eax

    ; Abrir o arquivo de saída para escrita
    invoke CreateFile, offset arquivo_string2, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL
    mov file_handle_write, eax
    
    ; Escrever os 44 bytes inicias do arquivo de entrada no arquivo de saída
    invoke ReadFile, file_handle_read, addr file_contents44, 44, addr bytes_read, NULL
    invoke WriteFile, file_handle_write, addr file_contents44, bytes_read, NULL, NULL

    ; Lê até 44 bytes do arquivo de entrada
    invoke ReadFile, file_handle_read, addr file_contents44, 44, addr bytes_read, NULL

    ; Escreve os bytes processados no arquivo de saída
    invoke WriteFile, file_handle_write, addr file_contents44, bytes_read, NULL, NULL

    ; Fechar os arquivos temporariamente após copiar o cabeçalho
    invoke CloseHandle, file_handle_read        
    invoke CloseHandle, file_handle_write

    ; Abrir o arquivo de entrada para leitura novamente para processar o restante
    invoke CreateFile, offset arquivo_string1 , GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL
    mov file_handle_read, eax

    ; Abrir o arquivo de saída para escrita novamente
    invoke CreateFile, addr arquivo_string2, GENERIC_WRITE, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL
    mov file_handle_write, eax

    ; Salta incondicionalmente para o rótulo 'copy_file_inalterado'
    jmp copy_file_inalterado 

copy_file_inalterado:
    ; Lê até 16 bytes do arquivo de entrada
    invoke ReadFile, file_handle_read, addr file_contents, 16, addr bytes_read, NULL

    ; Verificar se já copiou todos os bytes para o arquivo de saída
    cmp bytes_read, 0
    je fechar_arquivos ; Salta para o label de fechamento dos arquivos
    
    ; Escreve os bytes lidos no arquivo de saída
    invoke WriteFile, file_handle_write, addr file_contents, bytes_read, NULL, NULL

    ; Salta incondicionalmente ao label, recomeçando o processo
    jmp copy_file_inalterado

fechar_arquivos:
    ; Fechar os arquivos
    invoke CloseHandle, file_handle_read
    invoke CloseHandle, file_handle_write

    ; Abrir o arquivo de entrada para leitura novamente para processar o restante
    invoke CreateFile, offset arquivo_string1 , GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL
    mov file_handle_read, eax

    ; Abrir o arquivo de saída para escrita novamente
    invoke CreateFile, addr arquivo_string2, GENERIC_WRITE, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL
    mov file_handle_write, eax

    ; Escrever os 44 bytes inicias do arquivo de entrada no arquivo de saída
    invoke ReadFile, file_handle_read, addr file_contents44, 44, addr bytes_read, NULL
    invoke WriteFile, file_handle_write, addr file_contents44, bytes_read, NULL, NULL

    ; Salta para o label de copiar o arquivo
    jmp copy_file

copy_file:
    ; Lê até 16 bytes do arquivo de entrada
    invoke ReadFile, file_handle_read, addr file_contents, 16, addr bytes_read, NULL

    ; Se houver bytes lidos, processa as amostras de áudio
    cmp bytes_read, 0
    je done_copying

    ; Processar as amostras de áudio
    push reduction_factor       ; Constante de redução
    push offset file_after_div  ; Endereço do buffer de saida
    push offset file_contents   ; Endereço do buffer de entrada
    call process_audio_samples  ; Chamada da função de redução de volume

escrever_bytes_alterados:
    ; Escreve os bytes processados no arquivo de saída
    invoke WriteFile, file_handle_write, addr file_after_div, bytes_read, NULL, NULL
    
    jmp copy_file ; Salta para copiar o arquivo 

; Função para processar as amostras de áudio
process_audio_samples:
    push ebp
    mov ebp, esp
    
    mov esi, DWORD PTR[ebp+8] ; esi guarda o inicio do endereço do buffer de saida
    mov edi, DWORD PTR[ebp+12] ; edi guarda o inicio do endereço do buffer de saida
    mov bx, WORD PTR[ebp+16] ; bx guarda o valor da constante
    mov ecx, 8 ; Processar 8 amostras de 2 bytes (16 bytes no total)

process_loop:
    mov ax, [esi]     ; Carregar uma amostra de 2 bytes
    cwd               ; Extender sinal para EDX:EAX
    idiv bx           ; Dividir pela constante de redução fornecida pelo usuário
    mov [edi], ax     ; Armazenar o valor reduzido no buffer de saida
    add esi, 2        ; Avançar para a próxima amostra
    add edi, 2        ; Avançar para a próxima amostra
    loop process_loop ; Decrementa o contador 'ecx' e, se não for zero, repete o bloco de código
    mov esp, ebp      ; Restaura o ponteiro de pilha (ESP) ao valor que estava salvo em EBP
    pop ebp           ; Restaura o valor original do base pointer (EBP), voltando ao estado anterior
    ret 10            ; Retorna da função e remove 10 bytes da pilha

; Função para remover os caracteres CR ou LF
remover_caracter_cr:
    push ebp                  ; Salva o valor atual do base pointer (EBP) na pilha para restaurá-lo depois
    mov ebp, esp              ; Move o valor do stack pointer (ESP) para o base pointer (EBP), criando um novo quadro de pilha
    sub esp, 4                ; Reserva 4 bytes na pilha para uso como variáveis locais
    mov esi, DWORD PTR[ebp+8] ; Armazenar apontador da string em esi

proximo:
    mov al, [esi] ; Mover caractere atual para al
    inc esi       ; Apontar para o próximo caractere
    cmp al, 13    ; Verificar se é o caractere ASCII CR
    jne proximo   ; Se não for ASCII CR, retorna o processo para verificar o próximo caractere
    dec esi       ; Apontar para o caractere anterior
    xor al, al    ; ASCII 0
    mov [esi], al ; Inserir ASCII 0 no lugar do ASCII CR
    mov esp, ebp  ; Desfaz qualquer alocação local feita durante a função
    pop ebp       ; Restaura o valor original do base pointer (EBP), retirando-o da pilha
    ret 4         ; Retorna da função e remove 4 bytes da pilha

done_copying:
    ; Fechar os arquivos
    invoke CloseHandle, file_handle_read
    invoke CloseHandle, file_handle_write

    ; Pergunta ao usuário se deseja processar outro arquivo
    invoke WriteConsole, outputHandle, addr mensagem_novamente, sizeof mensagem_novamente, addr console_count, NULL
    invoke ReadConsole, inputHandle, addr resposta, sizeof resposta, addr console_count, NULL

    ; Se o usuário digitar 'S', reinicia o processo
    cmp byte ptr [resposta], 'S'
    je iniciar_processo

    ; Encerrar o programa
    jmp fim_do_programa

fim_do_programa:
    invoke ExitProcess, 0
    end main