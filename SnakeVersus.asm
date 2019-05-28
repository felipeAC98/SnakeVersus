; http://stackoverflow.com/questions/34217344/clear-screen-without-interrupt

INCLUDE Irvine32.inc
INCLUDE win32.inc
INCLUDE Macros.inc



COLS = 100; number of columns
ROWS = 30; number of rows
CHAR_ATTRIBUTE = 0Fh; COR BRANCA


.data
console HANDLE 0
buffer CHAR_INFO ROWS * COLS DUP(<< ' ' > , CHAR_ATTRIBUTE > )
bufferSize COORD <COLS, ROWS>
bufferCoord COORD <0, 0>
region SMALL_RECT <0, 0, COLS , ROWS >

x DWORD 0; current position
y DWORD 0; of the figure

caracterJog1 WORD '1'
caracterJog2 WORD '2'

posjog2x DWORD 98; posicao inicial do jogador
posjog2y DWORD 15;

sumjog2x SDWORD 0; posicao inicial do jogador
sumjog2y SDWORD 0;

posjog1x DWORD 1; posicao inicial do jogador 1
posjog1y DWORD 15;

sumjog1x SDWORD 0; Somador do jogador 1
sumjog1y SDWORD 0;

.code
main PROC

	INVOKE GetStdHandle, STD_OUTPUT_HANDLE
	mov console, eax; save console handle

	call printMoldura
	call iniciaMovimentacao

exit
main ENDP

;//################## FUNCAO DE MOVIMENTACAO E ATUALIZACAO DE TELA DO JOGO ##################
iniciaMovimentacao PROC

	ANIMATION:
	call DESENHACABECA1
	call DESENHACABECA2
	mov  eax, 100; sleep, to allow OS to time slice
	call Delay
	call ReadKey
	jz   ANIMATION; no key pressed yet

	;//################## VERIFICACAO MOVIMENTACAO JOGADOR 1 ##################//
	moveA:
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

	moveI:
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

iniciaMovimentacao ENDP

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

DESENHACABECA1 PROC USES eax edx ecx ebx

	mov bx, caracterJog1
	mov eax, sumjog1x
	add posjog1x, eax
	mov eax, sumjog1y
	add posjog1y, eax

	mov eax, posjog1y
	mov edx, COLS
	mul edx; multiplica edx com eax e coloca o resultado em eax.Ele multiplica pois para chegar na linha Y, eh necessario andar no vetor Y*tamanho da linha(numero de colunas)
	add eax, posjog1x
	mov buffer[eax * CHAR_INFO].Char, bx; aqui que eh o desenho da linha da tela

	invoke WriteConsoleOutput, console,
	ADDR buffer, bufferSize, bufferCoord, ADDR region

ret

DESENHACABECA1 ENDP

;//################## PROCEDIMENTO QUE EFETUA A MOVIMENTACAO JOGADOR 2 NA TELA ##################//

DESENHACABECA2 PROC USES eax edx ecx ebx

mov bx, caracterJog2
mov eax, sumjog2x
add posjog2x, eax
mov eax, sumjog2y
add posjog2y, eax

mov eax, posjog2y
mov edx, COLS
mul edx; multiplica edx com eax e coloca o resultado em eax.Ele multiplica pois para chegar na linha Y, eh necessario andar no vetor Y*tamanho da linha(numero de colunas)
add eax, posjog2x
mov buffer[eax * CHAR_INFO].Char, bx; aqui que eh o desenho da linha da tela

invoke WriteConsoleOutput, console,
ADDR buffer, bufferSize, bufferCoord, ADDR region

ret
DESENHACABECA2 ENDP

;//################## IMPRESSAO MOLDURA JOGO ##################// 

printMoldura PROC USES eax edx ecx

	mov caracterJog1, '*'

	mov ecx, COLS-1
	mov sumjog1x, 1
	mov sumjog1y, 0
	mov posjog1x, 0
	mov posjog1y, 0
molduraSuperior:
	call DESENHACABECA1
	loop molduraSuperior

	mov ecx, COLS -1
;	mov sumjog1x, 1
;	mov sumjog1y, 0
	mov posjog1x, 0
	mov posjog1y, ROWS -1

molduraInferior:
	call DESENHACABECA1
	loop molduraInferior

	mov ecx, ROWS -1
	mov sumjog1x, 0
	mov sumjog1y, 1
	mov posjog1x, 0
	mov posjog1y, 0
molduraEsquerda :
	call DESENHACABECA1
	loop molduraEsquerda

	mov ecx, ROWS  -1
	mov sumjog1x, 0
	mov sumjog1y, 1
	mov posjog1x, COLS -1
	mov posjog1y, 0

molduraDireita :
	call DESENHACABECA1
	loop molduraDireita

	mov sumjog1x, 0
	mov sumjog1y, 0
	mov posjog1x, 1
	mov posjog1y, 15

	mov caracterJog1, '1'
ret

printMoldura ENDP



	END main