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
	caractere WORD ?
	corCaracteree WORD ?
	posicaoX     DWORD ?
	posicaoY     DWORD ?
	somadorX SDWORD ?
	somadorY SDWORD ?
	atributosJogador ENDS


	.data

	; http://www.jasinskionline.com/windowsapi/ref/p/playsound.html

;// Declaracoes necessarias para as flags utilizadas na funcao do audio

VELOC DWORD 0

SND_ALIAS DWORD 00010000h

SND_ALIAS_ID DWORD 00110000h

SND_APPLICATION DWORD 00000080h

SND_ASYNC DWORD 00000001h

SND_SYNC DWORD 00000000h

SND_LOOP DWORD 00000008h

SND_LOOPASYNC DWORD 00000009h

SND_NOSTOP DWORD 00000010h

musicaFundo BYTE "c:\\musicaFundo.wav", 0
iniciaJogo BYTE "c:\\iniciaJogo.wav", 0
mover BYTE "c:\\mover.wav", 0
colisao BYTE "c:\\explosao.wav", 0
vencedor BYTE "c:\\vencedor.wav", 0

ultimaPosBuffer DWORD 0
cores BYTE 0
console HANDLE 0
moldura atributosJogador < 0DBh, 06h, 0, 0, 0, 0>
jogador1 atributosJogador < 0DBh, 05h, 1, ROWS / 2, 1, 0>
jogador2 atributosJogador < 0DBh, 09h, COLS - 2, ROWS / 2, -1, 0>

buffer atributosCaracteres ROWS * COLS DUP(<' ', 0Fh >)
bufferSize COORD <COLS, ROWS>
bufferCoord COORD <0, 0>
region SMALL_RECT <0, 0, COLS, ROWS >

Snake2   byte'                                                                                                    '
byte'                   ___           ___           ___           ___           ___                      '
byte'                  /  /\         /__/\         /  /\         /__/|         /  /\                     '
byte'                 /  /:/_        \  \:\       /  /::\       |  |:|        /  /:/_                    '
byte'                /  /:/ /\        \  \:\     /  /:/\:\      |  |:|       /  /:/ /\                   '
byte'               /  /:/ /::\   _____\__\:\   /  /:/_/::\   __|  |:|      /  /:/ /:/_                  '
byte'              /__/:/ /:/\:\ /__/::::::::\ /__/:/ /:/\:\ /__/\_|:|____ /__/:/ /:/ /\                 '
byte'              \  \:\/:/~/:/ \  \:\__\__\/ \  \:\/:/__\/ \  \:\/:::::/ \  \:\/:/ /:/                 '
byte'               \  \::/ /:/   \  \:\        \  \::/       \  \::/ ~~~   \  \::/ /:/                  '
byte'                \__\/ /:/     \  \:\        \  \:\        \  \:\        \  \:\/:/                   '
byte'                  /__/:/       \  \:\        \  \:\        \  \:\        \  \::/                    '
byte'                  \__\/         \__\/         \__\/         \__\/         \__\/                     ', 0



Snake   byte'                                                                                                    '
byte'                                                                                                    '
byte'                                                                                                    '
byte'                           ######  ##    ##    ###    ##    ## ########                             '
byte'                          ##    ## ###   ##   ## ##   ##   ##  ##                                   '
byte'                          ##       ####  ##  ##   ##  ##  ##   ##                                   '
byte'                           ######  ## ## ## ##     ## #####    ######                               '
byte'                                ## ##  #### ######### ##  ##   ##                                   '
byte'                          ##    ## ##   ### ##     ## ##   ##  ##                                   '
byte'                           ######  ##    ## ##     ## ##    ## ########                             '
byte'                                                                                                    '
byte'                                                                                                    ', 0


Versus  byte'                                                                                                    '
byte'                                                                                                    '
byte'            ##     ##    ########    ########      ######     ##     ##     ######                  '
byte'            ##     ##    ##          ##     ##    ##    ##    ##     ##    ##    ##                 '
byte'            ##     ##    ##          ##     ##    ##          ##     ##    ##                       '
byte'            ##     ##    ######      ########      ######     ##     ##     ######                  '
byte'             ##   ##     ##          ##   ##            ##    ##     ##          ##                 '
byte'              ## ##      ##          ##    ##     ##    ##    ##     ##    ##    ##                 '
byte'               ###       ########    ##     ##     ######      #######      ######                  '
byte'                                                                                                    '
byte'                                                                                                    '
byte'                     PRESSIONE SPACE PARA         PRESSIONE P PARA INSTRUCOES                       '
byte'                         INICIAR O JOGO                   SOBRE O JOGO                              ', 0



Versus2 byte'                                                                                           ', 0ah
byte'                  ___           ___           ___           ___           ___           ___       ', 0ah
byte'         ___     /__/\         /  /\         /  /\         /  /\         /__/\         /  /\      ', 0ah
byte'        /__/\    \_ \:\       /  /:/_       /  /::\       /  /:/_        \  \:\       /  /:/_     ', 0ah
byte'        \  \:\    \  \:\     /  /:/ /\     /  /:/\:\     /  /:/ /\        \  \:\     /  /:/ /\    ', 0ah
byte'         \  \:\    \  \:\   /  /:/ /:/_   /  /:/~/:/    /  /:/ /::\   ___  \  \:\   /  /:/ /::\   ', 0ah
byte'          \  \:\    \__\:\ /__/:/ /:/ /\ /__/:/ /:/___ /__/:/ /:/\:\ /__/\  \__\:\ /__/:/ /:/\:\  ', 0ah
byte'           \  \:\   |  |:| \  \:\/:/ /:/ \  \:\/:::::/ \  \:\/:/~/:/ \  \:\ /  /:/ \  \:\/:/~/:/  ', 0ah
byte'            \  \:\  |  |:|  \  \::/ /:/   \  \::/~~~~   \  \::/ /:/   \  \:\  /:/   \  \::/ /:/   ', 0ah
byte'             \  \:\_|__|:|   \  \:\/:/     \  \:\        \__\/ /:/     \  \:\/:/     \__\/ /:/    ', 0ah
byte'              \__\::::/:/     \  \::/       \  \:\         /__/:/       \  \::/        /__/:/     ', 0ah
byte'                  ~~~~         \__\/         \__\/         \__\/         \__\/         \__\/      ', 0ah
byte'                                                                                                  ', 0ah
byte'                                                                                                  ', 0ah
byte'                       PRESSIONE SPACE PARA         PRESSIONE P PARA INSTRUCOES                   ', 0ah
byte'                           INICIAR O JOGO                   SOBRE O JOGO                          ', 0

instruction byte'                                                                         ', 0ah
byte'                                       ___                 _                         ', 0ah
byte'               ___  ___  _____  ___   |  _| _ _  ___  ___ |_| ___  ___  ___          ', 0ah
byte'              |  _|| . ||     || . |  |  _|| | ||   ||  _|| || . ||   || . |         ', 0ah
byte'              |___||___||_|_|_||___|  |_|  |___||_|_||___||_||___||_|_||__,|         ', 0ah
byte'                                         _                                           ', 0ah
byte'                                 ___    |_| ___  ___  ___                            ', 0ah
byte'                                | . |   | || . || . || . |                           ', 0ah
byte'                                |___|  _| ||___||_  ||___|                           ', 0ah
byte'                                      |___|     |___|                                ', 0ah
byte'                                                                                     ', 0ah
byte'                                                                                     ', 0ah
byte'             O jogo Snake Versus tem como objetivo o duelo entre dois jogadores.     ', 0ah
byte'            Cada jogador deve movimentar sua Snake de forma que o campeao eh         ', 0ah
byte'            aquele que conseguir ficar o maior tempo sem colidir com a moldura       ', 0ah
byte'            que delimita a tela de movimentacao, seu proprio corpo ou o do seu       ', 0ah
byte'            ponente.                                                                 ', 0ah
byte'                                                                                     ', 0ah
byte'        Atencao, nao eh permitido pressionar duas vezes uma tecla para a mesma direcao!', 0ah
byte'                                                                                     ', 0ah
byte'                        Jogador 1                       Jogador 2                    ', 0ah
byte'                          ____                             ____                      ', 0ah
byte'                         ||W ||                           ||I ||                     ', 0ah
byte'                     ____||__||____                   ____||__||___                  ', 0ah
byte'                    ||A |||S |||D ||                 ||J |||K |||L ||                ', 0ah
byte'                    ||__|||__|||__||                 ||__|||__|||__||                ', 0ah
byte'                    |/__\|/__\|/__\|                 |/__\|/__\|/__\|                ', 0ah
byte'                                                                                     ', 0ah
byte'                          Pressione space para iniciar o jogo                        ', 0

velocidade byte"                                                                                 ", 0ah
byte"                                                                                            ", 0ah
byte"                                                                                            ", 0ah
byte"             __  __          ___                           __               __              ", 0ah
byte"            /\ \/\ \        /\_ \                   __    /\ \             /\ \             ", 0ah
byte"            \ \ \ \ \     __\//\ \     ___     ___ /\_\   \_\ \     __     \_\ \     __     ", 0ah
byte"             \ \ \ \ \  /' __`\ \ \  /' __`\  /'__\`/\ \ /' _`  \ /'__`\   /'_` \  /'__`\   ", 0ah
byte"              \ \ \_/ \/\  __/ \_\ \|/\ \ \ \/\ \__ \ \ \/\ \L\ \/\ \L\.\_/\ \L\ \/\  __/   ", 0ah
byte"               \ `\___/\ \____\/\____\ \____/\ \____\\ \_\ \___,_\ \__/.\_\ \___,_\ \____\  ", 0ah
byte"                `\/__/  \/____/\/____/\/___/  \/____/ \/_/\/__,_ /\/__/\/_/\/__,_ /\/____/  ", 0ah
byte"                                                                                            ", 0ah
byte"                                                                                            ", 0ah
byte"                                                                                            ", 0ah
byte"                                                                                            ", 0ah
byte"                               Pressione a velocidade que deseja jogar                      ", 0ah
byte"                                                                                            ", 0ah
byte"                                                                                            ", 0ah
byte"                        _                      ___                         __               ", 0ah
byte"                       /  \                   /'___`\                     /'__`\            ", 0ah
byte"                      /\_  \                 /\_\ /\ \                   /\_\L\ \           ", 0ah
byte"                      \/_/\ \                \/_/// /__                  \/_/_\_<_          ", 0ah
byte"                         \ \ \                  // /_\ \                   /\ \L\ \         ", 0ah
byte"                          \ \_\                /\______/                   \ \____/         ", 0ah
byte"                           \/_/                \/_____/                     \/___/          ", 0


jogador1Vencedor  byte'                                                                                                    '
byte'                                                                                                    '
byte'                                                                                                    '
byte'             ##  #######   ######      ###    ########   #######  ########          ##              '
byte'             ## ##     ## ##    ##    ## ##   ##     ## ##     ## ##     ##       ####              '
byte'             ## ##     ## ##         ##   ##  ##     ## ##     ## ##     ##         ##              '
byte'             ## ##     ## ##   #### ##     ## ##     ## ##     ## ########          ##              '
byte'       ##    ## ##     ## ##    ##  ######### ##     ## ##     ## ##   ##           ##              '
byte'       ##    ## ##     ## ##    ##  ##     ## ##     ## ##     ## ##    ##          ##              '
byte'        ######   #######   ######   ##     ## ########   #######  ##     ##       ######            '
byte'                                                                                                    '
byte'                                                                                                    '
byte'                    ######      ###    ##    ## ##     ##  #######  ##     ##                       '
byte'                   ##    ##    ## ##   ###   ## ##     ## ##     ## ##     ##                       '
byte'                   ##         ##   ##  ####  ## ##     ## ##     ## ##     ##                       '
byte'                   ##   #### ##     ## ## ## ## ######### ##     ## ##     ##                       '
byte'                   ##    ##  ######### ##  #### ##     ## ##     ## ##     ##                       '
byte'                   ##    ##  ##     ## ##   ### ##     ## ##     ## ##     ##                       '
byte'                    ######   ##     ## ##    ## ##     ##  #######   #######                        '
byte'                                                                                                    '
byte'                               PRESSIONE "S" PARA SAIR OU QUALQUER                                  '
byte'                           OUTRA TECLA PARA RETORNAR AO MENU INICIAL                                ', 0


jogador2Vencedor  			byte'                                                                                                    '
byte'                                                                                                    '
byte'                                                                                                    '
byte'             ##  #######   ######      ###    ########   #######  ########         #######          '
byte'             ## ##     ## ##    ##    ## ##   ##     ## ##     ## ##     ##       ##     ##         '
byte'             ## ##     ## ##         ##   ##  ##     ## ##     ## ##     ##              ##         '
byte'             ## ##     ## ##   #### ##     ## ##     ## ##     ## ########         #######          '
byte'       ##    ## ##     ## ##    ##  ######### ##     ## ##     ## ##   ##         ##                '
byte'       ##    ## ##     ## ##    ##  ##     ## ##     ## ##     ## ##    ##        ##                '
byte'        ######   #######   ######   ##     ## ########   #######  ##     ##       #########         '
byte'                                                                                                    '
byte'                                                                                                    '
byte'                    ######      ###    ##    ## ##     ##  #######  ##     ##                       '
byte'                   ##    ##    ## ##   ###   ## ##     ## ##     ## ##     ##                       '
byte'                   ##         ##   ##  ####  ## ##     ## ##     ## ##     ##                       '
byte'                   ##   #### ##     ## ## ## ## ######### ##     ## ##     ##                       '
byte'                   ##    ##  ######### ##  #### ##     ## ##     ## ##     ##                       '
byte'                   ##    ##  ##     ## ##   ### ##     ## ##     ## ##     ##                       '
byte'                    ######   ##     ## ##    ## ##     ##  #######   #######                        '
byte'                                                                                                    '
byte'                                 PRESSIONE "S" PARA SAIR OU QUALQUER                                '
byte'                              OUTRA TECLA PARA RETORNAR AO MENU INICIAL                             ', 0

; http://www.jasinskionline.com/windowsapi/ref/p/playsound.html


.code


main PROC
INVOKE GetStdHandle, STD_OUTPUT_HANDLE
mov console, eax; save console handle

menu::

;// chamada do menu com opcao de tela de instrucoes e inicio do jogo
call inicializarJogo

;// inicia o jogo

INICIA::
;// chamada da tela para escolha da velocidade a ser jogada
call Clrscr
call ClearBuffer
call escolheVelocidade

call Clrscr
INVOKE PlaySound, OFFSET iniciaJogo, NULL, SND_ASYNC
call printMoldura
call iniciaMovimentacao

;// Se retornar aqui eh pq colidiu

COLIDIU::
call houveColisao

;// finaliza partida apos uma colisao
INVOKE PlaySound, OFFSET vencedor, NULL, SND_ASYNC

fimPartida :
call alteraCores
mov  eax, 635; sleep, to allow OS to time slice
call Delay
call ReadKey
jz fimPartida
call ClearBuffer
call reinicializaJogadores
cmp al, 's'
je fimJogo
call Clrscr
jmp menu
fimJogo :
exit
main ENDP

;//#################################### FUNCAO DO MENU JOGO ####################################
inicializarJogo PROC

mov  eax, 06h
call SetTextColor

mov edx, OFFSET Snake
push edx

call transformaImpressao
; call WriteString
INVOKE PlaySound, OFFSET colisao, NULL, SND_ASYNC

mov  eax, 700;// Delay somente para tocar o som
call Delay

mov edx, OFFSET Versus
push edx
call transformaImpressao
; call WriteString
INVOKE PlaySound, OFFSET colisao, NULL, SND_ASYNC

mov  eax, 700;// Delay para nao cortar o som
call Delay

INVOKE PlaySound, OFFSET musicaFundo, NULL, SND_LOOPASYNC

L1 :
call alteraCores
mov  eax, 635; sleep, to allow OS to time slice
call Delay
call ReadKey
jz   L1
cmp dl, 20h
je fim
cmp dl, 50h
je L2
cmp dl, 070h
je L2
jmp L1

L2 :
call Clrscr
mov edx, OFFSET instruction
mov  eax, yellow
call SetTextColor
call WriteString

L3 :
call ReadChar
cmp al, 20h
jne L3
fim :

ret

inicializarJogo ENDP

;//#################################### FUNCAO DA TELA DE VELOCIDADES ####################################

escolheVelocidade PROC
mov edx, OFFSET velocidade
call WriteString
mov ebx, VELOC
L :
call ReadChar
cmp al, 31h
je N1
cmp al, 32h
je N2
cmp al, 33h
je N3
jmp L
N1 :
mov ebx, 100
jmp SAIR
N2 :
mov ebx, 75
jmp SAIR
N3 :
mov ebx, 50
SAIR :
	mov VELOC, ebx
	ret
	escolheVelocidade ENDP

	;//#################################### FUNCAO DE MOVIMENTACAO E ATUALIZACAO DE TELA DO JOGO ####################################
iniciaMovimentacao PROC

ANIMATION :
mov esi, OFFSET jogador1
call DESENHACARACTERE
mov esi, OFFSET jogador2
call DESENHACARACTERE
mov  eax, VELOC; sleep, to allow OS to time slice
call Delay
call ReadKey
jz   ANIMATION; no key pressed yet

;//#################################### VERIFICACAO MOVIMENTACAO JOGADOR 1 ####################################
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

somMover PROC
INVOKE PlaySound, OFFSET mover, NULL, SND_ASYNC
ret
somMover ENDP

MOVE_A PROC

cmp jogador1.somadorX, -1
jne semTrapaca
mov jogador1.somadorX, 1
jmp fim

semTrapaca :
mov jogador1.somadorX, -1
mov jogador1.somadorY, 0
call somMover

fim :
ret

MOVE_A ENDP

MOVE_D PROC
cmp jogador1.somadorX, 1
jne semTrapaca
mov jogador1.somadorX, -1
jmp fim

semTrapaca :
mov jogador1.somadorX, 1
mov jogador1.somadorY, 0
call somMover

fim :
ret
MOVE_D ENDP


MOVE_S PROC
cmp jogador1.somadorY, 1
jne semTrapaca
mov jogador1.somadorY, -1
jmp fim

semTrapaca :

mov jogador1.somadorY, 1
mov jogador1.somadorX, 0
call somMover

fim :
ret

MOVE_S ENDP

MOVE_W PROC
cmp jogador1.somadorY, -1
jne semTrapaca
mov jogador1.somadorY, 1
jmp fim

semTrapaca :


mov jogador1.somadorY, -1
mov jogador1.somadorX, 0
call somMover

fim :
ret
MOVE_W ENDP

;//################## PROCEDIMENTOS DE CONTROLE DA MOVIMENTACAO JOGADOR 2 ##################//

MOVE_J PROC

cmp jogador2.somadorX, -1
jne semTrapaca
mov jogador2.somadorX, 1
jmp fim

semTrapaca :

mov jogador2.somadorX, -1
mov jogador2.somadory, 0
call somMover

fim :
ret
MOVE_J ENDP

MOVE_L PROC


cmp jogador2.somadorX, 1
jne semTrapaca
mov jogador2.somadorX, -1
jmp fim

semTrapaca :

mov jogador2.somadorX, 1
mov jogador2.somadory, 0
call somMover
fim :
ret
MOVE_L ENDP


MOVE_K PROC


cmp jogador2.somadorY, 1
jne semTrapaca
mov jogador2.somadorY, -1
jmp fim

semTrapaca :

mov jogador2.somadory, 1
mov jogador2.somadorX, 0
call somMover
fim :
ret

MOVE_K ENDP

MOVE_I PROC

cmp jogador2.somadorY, -1
jne semTrapaca
mov jogador2.somadorY, 1
jmp fim

semTrapaca :

mov jogador2.somadory, -1
mov jogador2.somadorX, 0
call somMover
fim :
ret
MOVE_I ENDP

;//################## PROCEDIMENTO QUE EFETUA A INCERCAO DE CARACTERES NA TELA ##################//

DESENHACARACTERE PROC USES ecx

;// A estrutura ATRIBUTOJOGADOR é utilizada para a funcao de desenhar verificar onde cada objeto do jogo sera impresso (e suas caracteristicas), 
;// portanto eh apontado o inicio dela no registrador ESI (isso para cada jogador no momento em que for ser atualizado na tela)
;// para que seja possivel ler os valores dela (com auxilio de indices) e entao inserir na estrutura da tela

; caracter WORD ?
; corCaractere WORD ?
; posicaoX     DWORD ?
; posicaoY     DWORD ?
; somadorX SDWORD ?
; somadorY SDWORD ?
; jogador1 atributosJogador < 0DBh, 05h, 1, ROWS / 2, 0, 0>


mov eax, 0
mov ebx, 0
mov edx, 0
mov bx, WORD PTR[esi];			// Caractere
mov eax, SDWORD PTR[esi + 12];  // SomadorX
add[esi + 4], eax;				// NOVA PosicaoX 
mov eax, SDWORD PTR[esi + 16];  // Somador Y
add[esi + 8], eax;				// NOVA Posicao Y



mov eax, [esi + 8];    // Posicao Y
mov edx, COLS
mul edx; multiplica edx com eax e coloca o resultado em eax.Ele multiplica pois para chegar na linha Y, eh necessario andar no vetor Y*tamanho da linha(numero de colunas)
add eax, [esi + 4];    // Posicao X

call verificaColisao

mov buffer[eax * atributosCaracteres].Char, bx; posicao no vetor * tamanho de cada variavel
mov bx, WORD PTR[esi + 2];   // Cor caracter
mov buffer[eax * atributosCaracteres].Atributos, bx; aqui que eh o desenho da linha da tela
invoke WriteConsoleOutput, console,
ADDR buffer, bufferSize, bufferCoord, ADDR region

ret

DESENHACARACTERE ENDP

;//################## VERIFICA SE HOUVE COLISAO ##################// 

verificaColisao PROC

cmp buffer[eax * atributosCaracteres].Char, ' '
jne COLIDIU

ret
verificaColisao ENDP

houveColisao PROC
INVOKE PlaySound, OFFSET colisao, NULL, SND_SYNC
call ClearBuffer
cmp esi, OFFSET jogador1
je jogador1bateu

jogador2bateu :
mov  eax, 05h
call SetTextColor
push OFFSET jogador1Vencedor
call transformaImpressao
jmp fimPartida

jogador1bateu :
mov  eax, blue
call SetTextColor
push OFFSET jogador2Vencedor
call transformaImpressao

fimPartida :
ret
houveColisao ENDP
;//################## IMPRESSAO MOLDURA JOGO ##################// 
;//Essa funcao eh responsavel pela insercao da moldura de limitacao na tela em que a batalha entre as cobrinhas irá ocorrer

printMoldura PROC
mov esi, OFFSET moldura;	//indicando o endereco do objeto moldura
mov ecx, COLS - 2;			// definindo inicio da moldura superior
mov moldura.caractere, 0CDh
mov moldura.somadorX, 1
mov moldura.somadorY, 0
mov moldura.posicaoX, 0
mov moldura.posicaoY, 0
molduraSuperior:
call DESENHACARACTERE
loop molduraSuperior

mov ecx, COLS - 2
; mov moldura.somadorX, 1
; mov moldura.somadorY, 0
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

;//################## LIMPA BUFFER

;// Funcao responsavel por resetar o vetor de buffer em que as cobras se movimentam
;//o vetor eh preenchido por espacos em toda area util do jogo
ClearBuffer PROC USES eax
mov eax, 0

BLANKS :

mov buffer[eax * atributosCaracteres].Char, ' '
mov buffer[eax * atributosCaracteres].Atributos, 0fh
inc eax
cmp eax, ROWS * COLS
jl BLANKS
mov ultimaPosBuffer, 0;//resetando posicao inicial para printar tela
ret
ClearBuffer ENDP

;//################## REINICIALIZA JOGADORES

;//Uma vez que uma partida tiver sido terminada e uma nova for se iniciar eh necessario que as posicoes e as direcoes dos jogadores sejam resetadas
;//para aquelas iniciais. Essa funcao eh responsavel por essa alteracao

reinicializaJogadores PROC

mov jogador1.posicaox, 1
mov jogador2.posicaox, COLS - 2
mov jogador1.posicaoy, ROWS / 2
mov jogador2.posicaoy, ROWS / 2
mov jogador1.somadorx, 1
mov jogador2.somadorx, -1
mov jogador1.somadory, 0
mov jogador2.somadory, 0

ret
reinicializaJogadores ENDP

;//################## FUNCAO DE TRANSFORMACAO DA IMAGEM PARA O BUFFER
;// Funcao responsavel por transformar imagens previamente criadas no .data para o vetor buffer
;//que sera o responsavel pela impressao das mesmas

transformaImpressao PROC

push ebp
mov ebp, esp

mov eax, ultimaPosBuffer;// endereco no qual devera estar apontando a proxima posicao que algo sera impresso no buffer
mov edx, 0
mov ecx, DWORD PTR[ebp + 8];//apontando para o endereco da variavel que possui oque sera escrito


insereLinha:

movzx ebx, BYTE PTR[ecx + edx];//apontando para o endereco do proximo char a ser passado para o buffer
cmp ebx, 0ah
je proxChar
cmp ebx, '#'
jne naoAltera
mov bx, 0DBh
mov buffer[eax * atributosCaracteres].Char, bx
naoAltera :
mov buffer[eax * atributosCaracteres].Char, bx
mov buffer[eax * atributosCaracteres].Atributos, 0FH


proxChar :
inc eax
inc edx
cmp ebx, 0
jne insereLinha
mov ultimaPosBuffer, eax
invoke WriteConsoleOutput, console,
ADDR buffer, bufferSize, bufferCoord, ADDR region

pop ebp
ret 4
transformaImpressao ENDP

alteraCores PROC
mov dx, 0
mov eax, 0

proximoCaractere:

; cmp buffer[eax * atributosCaracteres].Char, ' '
; je naoAltera
mov buffer[eax * atributosCaracteres].Atributos, dx
naoAltera :
inc eax
add cores, 1
mov dl, cores
and dx, 00001111b
cmp eax, COLS*ROWS

jb proximoCaractere

invoke WriteConsoleOutput, console,
ADDR buffer, bufferSize, bufferCoord, ADDR region

ret
alteraCores ENDP

END main