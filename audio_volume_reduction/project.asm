
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
    file_after_div db 16 dup(?)

    bytes_read dd ? ; Variável para armazenar a quantidade de bytes lidos
    console_count dd 0 ; Variável para armazenar caracteres escritos na console

    ; Handle de entrada e saída
    inputHandle dd 0
    outputHandle dd 0
    
    ; Mensagens para o usuario
    mensagem1 db "Digite o nome do arquivo de entrada: ", 0h, 0h
    mensagem2 db "Digite o nome do arquivo de saida: ", 0h, 0h
    mensagem3 db "Digite a constante de reducao de volume (1 a 10): ", 0h
    
    ; Variáveis para guardar o conteúdo escrito pelo usuário
    arquivo_string1 db 50 dup(0)
    arquivo_string2 db 50 dup(0)
    valor_string db 10 dup(0)
    valor_teste dw 8

.code
main:
    invoke GetStdHandle, STD_INPUT_HANDLE
    mov inputHandle, eax
    
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle, eax

    ; Lê o nome do arquivo de entrada
    invoke WriteConsole, outputHandle, addr mensagem1, sizeof mensagem1, addr console_count, NULL
    invoke ReadConsole, inputHandle, addr arquivo_string1, sizeof arquivo_string1, addr console_count, NULL

    ; Chama uma função para remover o caracter CR
    push offset arquivo_string1
    call remover_caracter_cr

    ; Lê o nome do arquivo de saída
    invoke WriteConsole, outputHandle, addr mensagem2, sizeof mensagem1, addr console_count, NULL
    invoke ReadConsole, inputHandle, addr arquivo_string2, sizeof arquivo_string1, addr console_count, NULL

    ; Chama uma função para remover o caracter CR
    push offset arquivo_string2
    call remover_caracter_cr
    
    ; Abrir o arquivo de entrada para leitura
    invoke CreateFile, offset arquivo_string1 , GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL
    mov file_handle_read, eax

    ; Abrir o arquivo de saída para escrita
    invoke CreateFile, offset arquivo_string2, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL
    mov file_handle_write, eax
    
    ; Escrever os 44 bytes inicias do arquivo de entrada no arquivo de saída
    invoke ReadFile, file_handle_read, addr file_contents44, 44, addr bytes_read, NULL
    invoke WriteFile, file_handle_write, addr file_contents44, bytes_read, NULL, NULL

    ; Fechar os arquivos
    invoke CloseHandle, file_handle_read        
    invoke CloseHandle, file_handle_write

    ; Abrir o arquivo de entrada para leitura
    invoke CreateFile, offset arquivo_string1 , GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL
    mov file_handle_read, eax

    ; Abrir o arquivo de saída para escrita
    invoke CreateFile, addr arquivo_string2, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL
    mov file_handle_write, eax
    
    jmp copy_file
    
copy_file:
    ; Lê até 16 bytes do arquivo de entrada
    invoke ReadFile, file_handle_read, addr file_contents, 16, addr bytes_read, NULL

    ; Escreve os bytes lidos no arquivo de saída
    invoke WriteFile, file_handle_write, addr file_contents, bytes_read, NULL, NULL

    ; Verificar se já copiou todos os bytes para o arquivo de saída
    cmp bytes_read, 0
    jg copy_file

fechar_arquivos:
    ; Fechar os arquivos
    invoke CloseHandle, file_handle_read
    invoke CloseHandle, file_handle_write
    jmp fim_do_programa
    
; Função para remover os caracteres CR ou LF
remover_caracter_cr:
    push ebp
    mov ebp, esp
    sub esp, 4
    mov esi, DWORD PTR[ebp+8] ; Armazenar apontador da string em esi
    
proximo:
    mov al, [esi] ; Mover caractere atual para al
    inc esi ; Apontar para o proximo caractere
    cmp al, 13 ; Verificar se eh o caractere ASCII CR
    jne proximo
    dec esi ; Apontar para caractere anterior
    xor al, al ; ASCII 0
    mov [esi], al ; Inserir ASCII 0 no lugar do ASCII CR
    mov esp, ebp
    pop ebp
    ret 4

; Label que encerra o programa
fim_do_programa:
    invoke ExitProcess, 0
    end main