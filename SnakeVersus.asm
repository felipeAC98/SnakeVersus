; http://stackoverflow.com/questions/34217344/clear-screen-without-interrupt

INCLUDE Irvine32.inc
INCLUDE win32.inc
INCLUDE Macros.inc
includelib Winmm.lib

PlaySound PROTO,
pszSound : PTR BYTE,
	hmod : DWORD,
	fdwSound : DWORD

	COLS = 100; numero de colunas
	ROWS = 30; numero de linhas


	atributosCaracteres STRUCT
	Char          WORD ?
	Atributos    WORD ?
	atributosCaracteres ENDS

	atributosJogador STRUCT
	caractere	WORD ?
	corCaracteree WORD ?
	posicaoX     DWORD ?
	posicaoY     DWORD ?
	somadorX	SDWORD ?
	somadorY	SDWORD ?
	atributosJogador ENDS

	.data

	SND_FILENAME DWORD 00000001h
	SND_FILENAME2 DWORD 00000002h

	file BYTE "c:\\clap.wav", 0
	abertura BYTE "c:\\SnakeVersus.wav", 0

	console HANDLE 0
	moldura atributosJogador < 0DBh, 0Fh, 0, 0, 0, 0>
	jogador1 atributosJogador < 0DBh, 05h, 1, ROWS / 2, 1, 0>
	jogador2 atributosJogador < 0DBh, 09h, COLS - 2, ROWS / 2, -1, 0>

	buffer atributosCaracteres ROWS * COLS DUP(<' ', 0Fh >)
	bufferSize COORD <COLS, ROWS>
	bufferCoord COORD <0, 0>
	region SMALL_RECT <0, 0, COLS, ROWS >

	telaInicial byte'		  ___           ___           ___           ___           ___			', 0ah
	byte'	         /  /\         /__/\         /  /\         /__/|         /  /\					', 0ah
	byte'	        /  /:/_        \  \:\       /  /::\       |  |:|        /  /:/_					', 0ah
	byte'	       /  /:/ /\        \  \:\     /  /:/\:\      |  |:|       /  /:/ /\				', 0ah
	byte'	      /  /:/ /::\   _____\__\:\   /  /:/_/::\   __|  |:|      /  /:/ /:/_				', 0ah
	byte'             /__/:/ /:/\:\ /__/::::::::\ /__/:/ /:/\:\ /__/\_|:|____ /__/:/ /:/ /\			', 0ah
	byte'             \  \:\/:/~/:/ \  \:\__\__\/ \  \:\/:/__\/ \  \:\/:::::/ \  \:\/:/ /:/			', 0ah
	byte'              \  \::/ /:/   \  \:\        \  \::/       \  \::/ ~~~   \  \::/ /:/			', 0ah
	byte'               \__\/ /:/     \  \:\        \  \:\        \  \:\        \  \:\/:/		', 0ah
	byte'		 /__/:/       \  \:\        \  \:\        \  \:\        \  \::/					', 0ah
	byte'	         \__\/         \__\/         \__\/         \__\/         \__\/				', 0ah
	byte'                       ___           ___           ___           ___           ___           ___    ', 0ah
	byte'	        ___   /__/\         /  /\         /  /\         /  /\         /__/\         /  /\	', 0ah
	byte'	       /__/\  \_ \:\       /  /:/_       /  /::\       /  /:/_        \  \:\       /  /:/_	', 0ah
	byte'               \  \:\  \  \:\     /  /:/ /\     /  /:/\:\     /  /:/ /\        \  \:\     /  /:/ /\ ', 0ah
	byte'	        \  \:\  \  \:\   /  /:/ /:/_   /  /:/~/:/    /  /:/ /::\   ___  \  \:\   /  /:/ /::\', 0ah
	byte'		 \  \:\  \__\:\ /__/:/ /:/ /\ /__/:/ /:/___ /__/:/ /:/\:\ /__/\  \__\:\ /__/:/ /:/\:\	', 0ah
	byte'		  \  \:\ |  |:| \  \:\/:/ /:/ \  \:\/:::::/ \  \:\/:/~/:/ \  \:\ /  /:/ \  \:\/:/~/:/', 0ah
	byte'		   \  \:\|  |:|  \  \::/ /:/   \  \::/~~~~   \  \::/ /:/   \  \:\  /:/   \  \::/ /:/', 0ah
	byte'		    \  \:\__|:|   \  \:\/:/     \  \:\        \__\/ /:/     \  \:\/:/     \__\/ /:/	', 0ah
	byte'		     \__\::::/     \  \::/       \  \:\         /__/:/       \  \::/        /__/:/	', 0ah
	byte'			 ~~~~       \__\/         \__\/         \__\/         \__\/         \__\/		', 0ah
	byte'																								', 0ah
	byte'																								', 0ah
	byte'		      PRESSIONE SPACE PARA 		      PRESSIONE P PARA INSTRUCOES						', 0ah
	byte'			 INICIAR O JOGO					SOBRE O JOGO										', 0

	instruction     byte' ', 0ah
	byte'		                          ___                 _                     ', 0ah
	byte'		  ___  ___  _____  ___   |  _| _ _  ___  ___ |_| ___  ___  ___		', 0ah
	byte'		 |  _|| . ||     || . |  |  _|| | ||   ||  _|| || . ||   || . |     ', 0ah
	byte'		 |___||___||_|_|_||___|  |_|  |___||_|_||___||_||___||_|_||__,|     ', 0ah
	byte'                                       _									', 0ah
	byte'        	               ___    |_| ___  ___  ___							', 0ah
	byte'			      | . |   | || . || . || . |						', 0ah
	byte'			      |___|  _| ||___||_  ||___|						', 0ah
	byte'				    |___|     |___|									', 0ah
	byte'																				      ', 0ah
	byte'               O jogo Snake Versus tem como objetivo o duelo entre dois jogadores.   ', 0ah
	byte'               Cada jogador deve movimentar sua Snake de forma que o campeao eh      ', 0ah
	byte'               aquele que conseguir ficar o maior tempo sem colidir com a moldura    ', 0ah
	byte'	       que delimita a tela de movimentacao, seu proprio corpo ou o				  ', 0ah
	byte'	       do seu oponente.                                                           ', 0ah
	byte'                                                                                     ', 0ah
	byte'		          Jogador 1                       Jogador 2							  ', 0ah
	byte'		            ____                             ____							  ', 0ah
	byte'		           ||W ||                           ||I ||							  ', 0ah
	byte'		       ____||__||____                   ____||__||___						  ', 0ah
	byte'		      ||A |||S |||D ||                 ||J |||K |||L ||						  ', 0ah
	byte'		      ||__|||__|||__||                 ||__|||__|||__||						  ', 0ah
	byte'    	   	      |/__\|/__\|/__\|                 |/__\|/__\|/__\|					  ', 0ah
	byte'																					  ', 0ah
	byte'                            Pressione space para iniciar o jogo					  ', 0

	jogador1Vencedor byte'                                                                                                        ', 0ah
	byte'                                                                                                        ', 0ah
	byte'       $$$$$\                                 $$\                                    $$\                ', 0ah
	byte'       \__$$ |                                $$ |                                 $$$$ |               ', 0ah
	byte'          $$ |$$$$$$\  $$$$$$\  $$$$$$\  $$$$$$$ |$$$$$$\  $$$$$$\                 \_$$ |               ', 0ah
	byte'          $$ $$  __$$\$$  __$$\ \____$$\$$  __$$ $$  __$$\$$  __$$\                  $$ |               ', 0ah
	byte'    $$\   $$ $$ /  $$ $$ /  $$ |$$$$$$$ $$ /  $$ $$ /  $$ $$ |  \__|                 $$ |               ', 0ah
	byte'    $$ |  $$ $$ |  $$ $$ |  $$ $$  __$$ $$ |  $$ $$ |  $$ $$ |                       $$ |               ', 0ah
	byte'    \$$$$$$  \$$$$$$  \$$$$$$$ \$$$$$$$ \$$$$$$$ \$$$$$$  $$ |                     $$$$$$\              ', 0ah
	byte'     \______/ \______/ \____$$ |\_______|\_______|\______/\__|		           \______|			        ', 0ah
	byte'                      $$\   $$ |                                                                        ', 0ah
	byte'                      \$$$$$$  |                                                                        ', 0ah
	byte'                       \______/                                                                         ', 0ah
	byte'                                $$$$$$\                      $$\                                       ', 0ah
	byte'                               $$  __$$\                     $$ |                                         ', 0ah
	byte'                               $$ /  \__| $$$$$$\  $$$$$$$\  $$$$$$$\    $$$$$$\   $$\   $$\             ', 0ah
	byte'                               $$ |$$$$\  \____$$\ $$  __$$\ $$  __$$\  $$  __$$\  $$ |  $$ |       ', 0ah
	byte'                               $$ |\_$$ | $$$$$$$  $$ |  $$  $$ |  $$ | $$ /  $$ | $$ |  $$ |        ', 0ah
	byte'                               $$ |  $$  $$  __$$  $$ |  $$  $$ |  $$ | $$ |  $$ | $$ |  $$ |          ', 0ah
	byte'                               \$$$$$$   \$$$$$$$  $$ |  $$  $$ |  $$ | \$$$$$$  | \$$$$$$  |         ', 0ah
	byte'                                \______/  \_______ \__|  \__ \__|  \__|  \______/   \______/          ', 0


	jogador2Vencedor byte'                                                                                                        ', 0ah
	byte'                                                                                                        ', 0ah
	byte'       $$$$$\                                 $$\                                                        ', 0ah
	byte'       \__$$ |                                $$ |                                   $$$$$$\             ', 0ah
	byte'          $$ |$$$$$$\  $$$$$$\  $$$$$$\  $$$$$$$ |$$$$$$\  $$$$$$\                 $$  __$$\               ', 0ah
	byte'          $$ $$  __$$\$$  __$$\ \____$$\$$  __$$ $$  __$$\$$  __$$\                \__/  $$ |               ', 0ah
	byte'    $$\   $$ $$ /  $$ $$ /  $$ |$$$$$$$ $$ /  $$ $$ /  $$ $$ |  \__|               $$  ____/                ', 0ah
	byte'    $$ |  $$ $$ |  $$ $$ |  $$ $$  __$$ $$ |  $$ $$ |  $$ $$ |                     $$ |               ', 0ah
	byte'    \$$$$$$  \$$$$$$  \$$$$$$$ \$$$$$$$ \$$$$$$$ \$$$$$$  $$ |                     $$$$$$$$\              ', 0ah
	byte'     \______/ \______/ \____$$ |\_______|\_______|\______/\__|		           \________|			        ', 0ah
	byte'                      $$\   $$ |                                                                        ', 0ah
	byte'                      \$$$$$$  |                                                                        ', 0ah
	byte'                       \______/                                                                         ', 0ah
	byte'                                $$$$$$\                      $$\                                       ', 0ah
	byte'                               $$  __$$\                     $$ |                                         ', 0ah
	byte'                               $$ /  \__| $$$$$$\  $$$$$$$\  $$$$$$$\    $$$$$$\   $$\   $$\             ', 0ah
	byte'                               $$ |$$$$\  \____$$\ $$  __$$\ $$  __$$\  $$  __$$\  $$ |  $$ |       ', 0ah
	byte'                               $$ |\_$$ | $$$$$$$  $$ |  $$  $$ |  $$ | $$ /  $$ | $$ |  $$ |        ', 0ah
	byte'                               $$ |  $$  $$  __$$  $$ |  $$  $$ |  $$ | $$ |  $$ | $$ |  $$ |          ', 0ah
	byte'                               \$$$$$$   \$$$$$$$  $$ |  $$  $$ |  $$ | \$$$$$$  | \$$$$$$  |         ', 0ah
	byte'                                \______/  \_______ \__|  \__ \__|  \__|  \______/   \______/          ', 0




	.code
	main PROC

	menu:
	INVOKE PlaySound, OFFSET abertura, NULL, SND_FILENAME2
	call inicializarJogo

	INICIA::
	call Clrscr
	INVOKE PlaySound, OFFSET file, NULL, SND_FILENAME
	INVOKE GetStdHandle, STD_OUTPUT_HANDLE
	mov console, eax; save console handle

	call printMoldura
	
	call iniciaMovimentacao

	COLIDIU::
	call Clrscr
	cmp esi, OFFSET jogador1
	je jogador1bateu
	jogador2bateu :
	mov edx, OFFSET jogador1Vencedor
	call WriteString
	jmp fim
	jogador1bateu :

	mov edx, OFFSET jogador2Vencedor
	call WriteString

	fim : call ReadChar
	exit
	main ENDP

	;//################## FUNCAO PARA INICIALIZACAO DO JOGO
inicializarJogo PROC

mov edx, OFFSET telaInicial

L1 :
call WriteString
call ReadChar
cmp al, 20h
je INICIA
cmp al, 50h
je L2
cmp al, 070h
je L2
jmp L1

L2 :
call Clrscr
mov edx, OFFSET instruction
call WriteString
call ReadChar
cmp al, 20h
je INICIA
jmp L2

ret

inicializarJogo ENDP

;//################## FUNCAO DE MOVIMENTACAO E ATUALIZACAO DE TELA DO JOGO ##################
iniciaMovimentacao PROC

ANIMATION :
mov esi, OFFSET jogador1
call DESENHACARACTERE
mov esi, OFFSET jogador2
call DESENHACARACTERE
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

MOVE_A PROC

mov jogador1.somadorX, -1
mov jogador1.somadorY, 0
ret

MOVE_A ENDP

MOVE_D PROC

mov jogador1.somadorX, 1
mov jogador1.somadorY, 0
ret
MOVE_D ENDP


MOVE_S PROC

mov jogador1.somadorY, 1
mov jogador1.somadorX, 0
ret

MOVE_S ENDP

MOVE_W PROC

mov jogador1.somadorY, -1
mov jogador1.somadorX, 0
ret
MOVE_W ENDP

;//################## PROCEDIMENTOS DE CONTROLE DA MOVIMENTACAO JOGADOR 2 ##################//

MOVE_J PROC

mov jogador2.somadorX, -1
mov jogador2.somadory, 0
ret
MOVE_J ENDP

MOVE_L PROC

mov jogador2.somadorX, 1
mov jogador2.somadory, 0
ret
MOVE_L ENDP


MOVE_K PROC

mov jogador2.somadory, 1
mov jogador2.somadorX, 0
ret

MOVE_K ENDP

MOVE_I PROC

mov jogador2.somadory, -1
mov jogador2.somadorX, 0
ret
MOVE_I ENDP

;//################## PROCEDIMENTO QUE EFETUA A INCERCAO DE CARACTERES NA TELA ##################//

DESENHACARACTERE PROC USES ecx

;// A estrutura ATRIBUTOJOGADOR é utilizada para a funcao de desenhar verificar onde cada objeto do jogo sera impresso (e suas caracteristicas), 
;// portanto eh apontado o inicio dela no registrador ESI (isso para cada jogador no momento em que for ser atualizado na tela)
;// para que seja possivel ler os valores dela (com auxilio de indices) e entao inserir na estrutura da tela

; caracter	WORD ?
; corCaractere WORD ?
; posicaoX     DWORD ?
; posicaoY     DWORD ?
; somadorX	SDWORD ?
; somadorY	SDWORD ?
; jogador1 atributosJogador < 0DBh, 05h, 1, ROWS / 2, 0, 0>


mov eax, 0
mov ebx, 0
mov edx, 0
mov bx, WORD PTR[esi];				// Caractere
mov eax, SDWORD PTR[esi + 12];		// SomadorX
add[esi + 4], eax;					// NOVA PosicaoX	
mov eax, SDWORD PTR[esi + 16];		// Somador Y
add[esi + 8], eax;					// NOVA Posicao Y



mov eax, [esi + 8];				// Posicao Y
mov edx, COLS
mul edx; multiplica edx com eax e coloca o resultado em eax.Ele multiplica pois para chegar na linha Y, eh necessario andar no vetor Y*tamanho da linha(numero de colunas)
add eax, [esi + 4];				// Posicao X

call verificaColisao

mov buffer[eax * atributosCaracteres].Char, bx; posicao no vetor * tamanho de cada variavel
mov bx, WORD PTR[esi + 2];			// Cor caracter
mov buffer[eax * atributosCaracteres].Atributos, bx; aqui que eh o desenho da linha da tela
invoke WriteConsoleOutput, console,
ADDR buffer, bufferSize, bufferCoord, ADDR region

ret

DESENHACARACTERE ENDP

verificaColisao PROC

cmp buffer[eax * atributosCaracteres].Char, ' '
jne COLIDIU

ret
verificaColisao ENDP


;//################## IMPRESSAO MOLDURA JOGO ##################// 

printMoldura PROC
mov esi, OFFSET moldura; //indicando o endereco do objeto moldura
mov ecx, COLS - 2
;// definindo inicio da moldura superior
mov moldura.caractere, 0CDh
mov moldura.somadorX, 1
mov moldura.somadorY, 0
mov moldura.posicaoX, 0
mov moldura.posicaoY, 0
molduraSuperior:
call DESENHACARACTERE
loop molduraSuperior

mov ecx, COLS - 2
;	mov moldura.somadorX, 1
;	mov moldura.somadorY, 0
mov moldura.posicaoX, 0
mov moldura.posicaoY, ROWS - 1

molduraInferior:
call DESENHACARACTERE
loop molduraInferior


mov  moldura.caractere, 0C9h
mov ecx, ROWS - 2
mov moldura.somadorX, 0
mov moldura.somadorY, 1
mov moldura.posicaoX, 0
mov moldura.posicaoY, -1
call DESENHACARACTERE
mov  moldura.caractere, 0BAh

molduraEsquerda :
call DESENHACARACTERE
loop molduraEsquerda
mov  moldura.caractere, 0C8h
call DESENHACARACTERE

mov  moldura.caractere, 0BBh
mov ecx, ROWS - 2
mov  moldura.somadorX, 0
mov moldura.somadorY, 1
mov moldura.posicaoX, COLS - 1
mov moldura.posicaoY, -1
call DESENHACARACTERE
mov  moldura.caractere, 0BAh
molduraDireita :
call DESENHACARACTERE
loop molduraDireita
mov  moldura.caractere, 0BCh
call DESENHACARACTERE


mov  moldura.caractere, 0DBh
ret

printMoldura ENDP
ClearBuffer PROC USES eax
mov eax, 0

BLANKS :
mov buffer[eax * CHAR_INFO].Char, ' '
inc eax
cmp eax, ROWS * COLS
jl BLANKS

ret
ClearBuffer ENDP
END main