.686
.model flat, stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib

.data
    ; Handle dos arquivos de entrada e saída
    file_handle_write dd ?
    file_handle_read dd ?
     
    ; Buffers para armazenar o conteúdo lido 16 bytes e 44 bytes              
    file_contents db 16 dup(?) 
    file_contents44 db 44 dup(?) 

    bytes_read dd ? ; Variável para armazenar a quantidade de bytes lidos
    console_count dd 0 ; Variável para armazenar caracteres escritos na console

    ; Handle de entrada e saída
    inputHandle dd 0
    outputHandle dd 0
    
    ; Mensagens para o usuario
    mensagem1 db "Arquivo de entrada: ", 0h, 0h
    mensagem2 db "Arquivo de saida: ", 0h, 0h
    mensagem3 db "Digite a constante de reducao de volume (1 a 10): ", 0h

    ; Variáveis para guardar o conteúdo escrito pelo usuário
    arquivo_string1 db 50 dup(0)
    arquivo_string2 db 50 dup(0)
    valor_reducao db 10 dup(0) ; Para armazenar a entrada da constante de volume
    reduction_factor dw ? ; Constante de redução convertida para número

.code
main:
    invoke GetStdHandle, STD_INPUT_HANDLE
    mov inputHandle, eax
    
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

    ; Abrir o arquivo de entrada para leitura
    invoke CreateFile, offset arquivo_string1 , GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL
    mov file_handle_read, eax

    ; Abrir o arquivo de saída para escrita
    invoke CreateFile, offset arquivo_string2, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL
    mov file_handle_write, eax
    
    ; Escrever os 44 bytes iniciais do arquivo de entrada no arquivo de saída
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
    
    jmp copy_file_inalterado

copy_file_inalterado:    
    ; Lê até 16 bytes do arquivo de entrada
    invoke ReadFile, file_handle_read, addr file_contents, 16, addr bytes_read, NULL

    ; Verificar se já copiou todos os bytes para o arquivo de saída
    cmp bytes_read, 0
    jle fechar_arquivos
    
    ; Escreve os bytes lidos no arquivo de saída
    invoke WriteFile, file_handle_write, addr file_contents, bytes_read, NULL, NULL
    
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

    ; Escrever os 44 bytes inicias do arquivo de entrada no arquivo de saída
    invoke ReadFile, file_handle_read, addr file_contents44, 44, addr bytes_read, NULL
    invoke WriteFile, file_handle_write, addr file_contents44, bytes_read, NULL, NULL

    mov file_handle_write, eax
    jmp copy_file

copy_file:
    ; Lê até 16 bytes do arquivo de entrada
    invoke ReadFile, file_handle_read, addr file_contents, 16, addr bytes_read, NULL

    ; Se houver bytes lidos, processa as amostras de áudio
    cmp bytes_read, 0
    jle done_copying

    ; Processar as amostras de áudio
    call process_audio_samples

    ; Escreve os bytes processados no arquivo de saída
    invoke WriteFile, file_handle_write, addr file_contents, bytes_read, NULL, NULL

    jmp copy_file

done_copying:
    ; Fechar os arquivos
    invoke CloseHandle, file_handle_read
    invoke CloseHandle, file_handle_write

    ; Encerrar o programa
    jmp fim_do_programa

; Função para remover os caracteres CR ou LF
remover_caracter_cr:
    push ebp
    mov ebp, esp
    sub esp, 4
    mov esi, DWORD PTR[ebp+8] ; Armazenar apontador da string em esi
proximo:
    mov al, [esi] ; Mover caractere atual para al
    inc esi ; Apontar para o próximo caractere
    cmp al, 13 ; Verificar se é o caractere ASCII CR
    jne proximo
    dec esi ; Apontar para o caractere anterior
    xor al, al ; ASCII 0
    mov [esi], al ; Inserir ASCII 0 no lugar do ASCII CR
    mov esp, ebp
    pop ebp
    ret 4

; Função para processar as amostras de áudio
process_audio_samples:
    push ebp
    mov ebp, esp
    mov esi, offset file_contents ; Apontar para o início do buffer
    mov ecx, 8 ; Processar 8 amostras de 2 bytes (16 bytes no total)

process_loop:
    mov ax, [esi] ; Carregar uma amostra de 2 bytes
    cwd            ; Extender sinal para EDX:EAX
    idiv reduction_factor ; Dividir pela constante de redução fornecida pelo usuário
    mov [esi], ax ; Armazenar o valor reduzido de volta no buffer
    add esi, 2 ; Avançar para a próxima amostra
    loop process_loop
    mov esp, ebp
    pop ebp
    ret

fim_do_programa:
    invoke ExitProcess, 0
    end main