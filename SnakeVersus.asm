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

posx DWORD 1; posicao inicial do jogador
posy DWORD 15;

sumx SDWORD 0; posicao inicial do jogador
sumy SDWORD 0;
character WORD '0'; filled with this symbol


.code
main PROC

INVOKE GetStdHandle, STD_OUTPUT_HANDLE
mov console, eax; save console handle

INICIALIZATION :
mov character, '*'
call RenderScene
invoke WriteConsoleOutput, console,
ADDR buffer, bufferSize, bufferCoord, ADDR region
INVOKE Sleep, 250; delay between frames

ANIMATION :
call DRAWPOINT
mov  eax, 50; sleep, to allow OS to time slice
call Delay
call ReadKey
jz   ANIMATION; no key pressed yet
mov character, dx


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
jne ANIMATION
call MOVE_W
jmp ANIMATION


exit
main ENDP

; Toda vez que eh apertado algum botao de movimentacao alguma das funcoes abaixo sera chamada para realizar a soma na direcao a ser movimentada
; e entao chamar a funcao DRAWPOINT para desenhar um ponto na posicao resultante da soma

MOVE_A PROC USES eax edx

mov sumx, -1
mov sumy, 0
ret

MOVE_A ENDP

MOVE_D PROC USES eax edx ecx

mov sumx, 1
mov sumy, 0
ret
MOVE_D ENDP


MOVE_S PROC USES eax edx ecx

mov sumy, 1
mov sumx, 0
ret

MOVE_S ENDP

MOVE_W PROC USES eax edx

mov sumy, -1
mov sumx, 0
ret
MOVE_W ENDP

DRAWPOINT PROC USES eax edx ecx
mov eax, sumx
add posx, eax
mov eax, sumy
add posy, eax

mov eax, posy
mov edx, COLS
mul edx; multiplica edx com eax e coloca o resultado em eax.Ele multiplica pois para chegar na linha Y, eh necessario andar no vetor Y*tamanho da linha(numero de colunas)
add eax, posx
mov buffer[eax * CHAR_INFO].Char, 'T'; aqui que eh o desenho da linha da tela

invoke WriteConsoleOutput, console,
ADDR buffer, bufferSize, bufferCoord, ADDR region
INVOKE Sleep, 25; delay between frames
ret

DRAWPOINT ENDP




; # Essa funcao(e a proxima) sao responsaveis por desenhar a tela inicial do jogo

CharToBuffer PROC USES eax edx bufx : DWORD, bufy : DWORD, char : WORD
mov eax, bufy; bufy = parametro edx = y
mov edx, COLS
mul edx; multiplica edx e eax
add eax, bufx
mov dx, char

cmp bufx, 0
jne t2
mov buffer[eax * CHAR_INFO].Char, dx;
jmp fimDesenho
t2 :
cmp bufx, COLS - 1
jne t3
mov buffer[eax * CHAR_INFO].Char, dx;
jmp fimDesenho

t3 :
cmp bufy, 0
jne t4
mov buffer[eax * CHAR_INFO].Char, dx;
jmp fimDesenho

t4 :
cmp bufy, ROWS - 1
jne fimDesenho
mov buffer[eax * CHAR_INFO].Char, dx;


fimDesenho:
ret
CharToBuffer ENDP


; Segunda funcao responsavel por desenhar tela inicial

RenderScene PROC USES eax edx ecx
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

	; inc x; increment x for the next frame
	; inc character; change fill character for the next frame

	ret
	RenderScene ENDP



	END main