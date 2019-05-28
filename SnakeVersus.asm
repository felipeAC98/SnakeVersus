TITLE Animation example
;; http://stackoverflow.com/questions/34217344/clear-screen-without-interrupt

INCLUDE Irvine32.inc
INCLUDE win32.inc
INCLUDE Macros.inc



COLS = 100; number of columns
ROWS = 30; number of rows
CHAR_ATTRIBUTE = 0Fh; bright white foreground


.data
console HANDLE 0
buffer CHAR_INFO ROWS * COLS DUP(<< ' ' > , CHAR_ATTRIBUTE > )
bufferSize COORD <COLS, ROWS>
bufferCoord COORD <0, 0>
region SMALL_RECT <0, 0, COLS - 1, ROWS - 1>

x DWORD 0; current position
y DWORD 0; of the figure

posjog2x DWORD 99; posicao inicial do jogador
posjog2y DWORD 15;

sumjog2x SDWORD 0; posicao inicial do jogador
sumjog2y SDWORD 0;

posjog1x DWORD 1; posicao inicial do jogador
posjog1y DWORD 15;

sumjog1x SDWORD 0; posicao inicial do jogador
sumjog1y SDWORD 0;

character WORD '0'; filled with this symbol


.code
main PROC

INVOKE GetStdHandle, STD_OUTPUT_HANDLE
mov console, eax; save console handle

INICIALIZATION :
mov character, '*'
call printTelaInicial
invoke WriteConsoleOutput, console,
ADDR buffer, bufferSize, bufferCoord, ADDR region
INVOKE Sleep, 100; delay between frames

ANIMATION :
call DESENHACABECA1
call DESENHACABECA2
mov  eax, 100; sleep, to allow OS to time slice
call Delay
call ReadKey
jz   ANIMATION; no key pressed yet
mov character, dx

;//################## VERIFICACAO MOVIMENTACAO JOGADOR 1 ##################//
moveA :
cmp dx, 'A'
jne moveD
call MOVE_A
jmp ANIMATION

moveD :
cmp dx, 'D'
jne moveS
call MOVE_D
jmp ANIMATION

moveS :
cmp dx, 'S'
jne moveW
call MOVE_S
jmp ANIMATION

moveW :
cmp dx, 'W'
jne moveI
call MOVE_W
jmp ANIMATION

;//################## VERIFICACAO MOVIMENTACAO JOGADOR 2 ##################//

moveI :
cmp dx, 'I'
jne moveJ
call MOVE_I
jmp ANIMATION

moveJ :
cmp dx, 'J'
jne moveL
call MOVE_J
jmp ANIMATION

moveL :
cmp dx, 'L'
jne moveK
call MOVE_L
jmp ANIMATION

moveK :
cmp dx, 'K'
jne ANIMATION
call MOVE_K
jmp ANIMATION

exit
main ENDP

;//################## PROCEDIMENTOS DE CONTROLE DA MOVIMENTACAO JOGADOR 1 ##################//

;// Toda vez que eh apertado algum botao de movimentacao alguma das funcoes abaixo sera chamada para setar o valor de quanto se deve somar em X e 
;// quanto se deve somar em Y para que o objeto se mov na direcao desejada

MOVE_A PROC USES eax edx

mov sumjog1x, -1
mov sumjog1y, 0
ret

MOVE_A ENDP

MOVE_D PROC USES eax edx ecx

mov sumjog1x, 1
mov sumjog1y, 0
ret
MOVE_D ENDP


MOVE_S PROC USES eax edx ecx

mov sumjog1y, 1
mov sumjog1x, 0
ret

MOVE_S ENDP

MOVE_W PROC USES eax edx

mov sumjog1y, -1
mov sumjog1x, 0
ret
MOVE_W ENDP

;//################## PROCEDIMENTOS DE CONTROLE DA MOVIMENTACAO JOGADOR 2 ##################//

MOVE_J PROC USES eax edx

mov sumjog2x, -1
mov sumjog2y, 0
ret
MOVE_J ENDP

MOVE_L PROC USES eax edx ecx

mov sumjog2x, 1
mov sumjog2y, 0
ret
MOVE_L ENDP


MOVE_K PROC USES eax edx ecx

mov sumjog2y, 1
mov sumjog2x, 0
ret

MOVE_K ENDP

MOVE_I PROC USES eax edx

mov sumjog2y, -1
mov sumjog2x, 0
ret
MOVE_I ENDP

;//################## PROCEDIMENTO QUE EFETUA A MOVIMENTACAO JOGADOR 1 NA TELA ##################//

DESENHACABECA1 PROC USES eax edx ecx
	mov eax, sumjog1x
	add posjog1x, eax
	mov eax, sumjog1y
	add posjog1y, eax

	mov eax, posjog1y
	mov edx, COLS
	mul edx; multiplica edx com eax e coloca o resultado em eax.Ele multiplica pois para chegar na linha Y, eh necessario andar no vetor Y*tamanho da linha(numero de colunas)
	add eax, posjog1x
	mov buffer[eax * CHAR_INFO].Char, '1'; aqui que eh o desenho da linha da tela

	invoke WriteConsoleOutput, console,
	ADDR buffer, bufferSize, bufferCoord, ADDR region

ret

DESENHACABECA1 ENDP

;//################## PROCEDIMENTO QUE EFETUA A MOVIMENTACAO JOGADOR 2 NA TELA ##################//

DESENHACABECA2 PROC USES eax edx ecx
mov eax, sumjog2x
add posjog2x, eax
mov eax, sumjog2y
add posjog2y, eax

mov eax, posjog2y
mov edx, COLS
mul edx; multiplica edx com eax e coloca o resultado em eax.Ele multiplica pois para chegar na linha Y, eh necessario andar no vetor Y*tamanho da linha(numero de colunas)
add eax, posjog2x
mov buffer[eax * CHAR_INFO].Char, '2'; aqui que eh o desenho da linha da tela

invoke WriteConsoleOutput, console,
ADDR buffer, bufferSize, bufferCoord, ADDR region

ret
DESENHACABECA2 ENDP




;// As próximas funcoes sao responsaveis por desenhar a tela inicial do jogo

CharToBuffer PROC USES eax edx bufx : DWORD, bufy : DWORD, char : WORD
mov eax, bufy; bufy = parametro edx = y
mov edx, COLS
mul edx; multiplica edx e eax
add eax, bufx
mov dx, char

cmp bufx, 0
jne molduraDireita
mov buffer[eax * CHAR_INFO].Char, dx;
jmp fimDesenho

molduraDireita :
cmp bufx, COLS -1
jne molduraSuperior
mov buffer[eax * CHAR_INFO].Char, dx;
jmp fimDesenho

molduraSuperior :
cmp bufy, 0
jne molduraInferior
mov buffer[eax * CHAR_INFO].Char, dx;
jmp fimDesenho

molduraInferior :
cmp bufy, ROWS -1
jne fimDesenho
mov buffer[eax * CHAR_INFO].Char, dx;


fimDesenho:
ret
CharToBuffer ENDP


;// Segunda funcao responsavel por desenhar tela inicial

printTelaInicial PROC USES eax edx ecx
mov edx, y
mov ecx, ROWS
ONELINE : ; 'Dois loops encadeados aqui'
	mov eax, x

	push ecx
	mov ecx, COLS

	ONECHAR : ; 'O outro aqui'
	INVOKE CharToBuffer, eax, edx, character; edx = y
	inc eax
	loop ONECHAR; inner loop prints characters
	inc edx
	pop ecx
	loop ONELINE; outer loop prints lines

	ret
printTelaInicial ENDP



	END main