; http://stackoverflow.com/questions/34217344/clear-screen-without-interrupt

INCLUDE Irvine32.inc
INCLUDE win32.inc
INCLUDE Macros.inc
includelib Winmm.lib


;// Necessario para reproducao do som
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

	
;// Eh necessario que os 5 arquivos de sons do jogo estejam presentes na pasta C: do computador
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

	Snake   byte'                                                                                                    '
	byte'                                                                                                    '
	byte'                                                                                                    '
	byte'                     ######     ##    ##       ###       ##    ##    ########                       '
	byte'                    ##    ##    ###   ##      ## ##      ##   ##     ##                             '
	byte'                    ##          ####  ##     ##   ##     ##  ##      ##                             '
	byte'                     ######     ## ## ##    ##     ##    #####       ######                         '
	byte'                          ##    ##  ####    #########    ##  ##      ##                             '
	byte'                    ##    ##    ##   ###    ##     ##    ##   ##     ##                             '
	byte'                     ######     ##    ##    ##     ##    ##    ##    ########                       '
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
	
	molduraStatica  byte'####################################################################################################'
	byte'#                                                                                                  #'
	byte'#                                                                                                  #'
	byte'#                                                                                                  #'
	byte'#                                                                                                  #'
	byte'#                                                                                                  #'
	byte'#                                                                                                  #'
	byte'#                                                                                                  #'
	byte'#                                                                                                  #'
	byte'#                                                                                                  #'
	byte'#                                                                                                  #'
	byte'#                                                                                                  #'
	byte'#                                                                                                  #'
	byte'#                                                                                                  #'
	byte'#                                                                                                  #'
	byte'#                                                                                                  #'
	byte'#                                                                                                  #'
	byte'#                                                                                                  #'
	byte'#                                                                                                  #'
	byte'#                                                                                                  #'
	byte'#                                                                                                  #'
	byte'#                                                                                                  #'
	byte'#                                                                                                  #'
	byte'#                                                                                                  #'
	byte'#                                                                                                  #'
	byte'#                                                                                                  #'
	byte'#                                                                                                  #'
	byte'#                                                                                                  #'
	byte'#                                                                                                  #'
	byte'####################################################################################################', 0





.code


main PROC

	INVOKE GetStdHandle, STD_OUTPUT_HANDLE
	mov console, eax										;// parametro necessario para a funcao que ira inserir os caracteres na tela

	menu::

	;// chamada do menu com opcao de tela de instrucoes e inicio do jogo
	call inicializarJogo

	INICIA::
	
	call Clrscr												;//limpando a tela
	call ClearBuffer										;//limpando o vetor de caracteres da tela

	;// chamada da tela para escolha da velocidade a ser jogada

	call escolheVelocidade
	call Clrscr												;//limpando a tela
	
	
	;// inicializando o jogo(partida) propriamente dito
	
	INVOKE PlaySound, OFFSET iniciaJogo, NULL, SND_ASYNC
	call printMoldura;										//funcao para desenhar a moldura do jogo no vetor de caracteres "buffer"
	call iniciaMovimentacao;								//iniciando a movimentacao dos jogadores

	
	;// Se retornar aqui eh pq colidiu

	COLIDIU::;												//Funcao para verificar qual dos jogadores colidiu
	call houveColisao

	;// finaliza partida apos uma colisao
	INVOKE PlaySound, OFFSET vencedor, NULL, SND_ASYNC

	fimPartida :
	call alteraCores
	
	mov  eax, 635; 											//Este delay eh somente para ter um controle da taxa de atualizacao das cores
	call Delay
	call ReadKey
	jz fimPartida;											//Enquanto nada for pressionado o loop continua e as cores permanecem se alterando
	
	mov  eax, 1500;											// Delay para se caso alguem tenha apertado algum botao na transicao da tela do jogo para a de game over a mesma nao desaparecer rapidamente

	cmp dx, 'S'			
	je fimJogo;												//Se for pressionado "S" entao o jogo se encerra

	call Delay
	call reinicializaJogadores;								//Reinicializando posicao dos jogadores
	call ClearBuffer;										//limpando o vetor de caracteres da tela
	
	jmp menu
	fimJogo :
	
	exit
main ENDP

;//#################################### FUNCAO DO MENU JOGO ####################################

inicializarJogo PROC

	;//O jogo inicia com a impressao da palavra SNAKE e depois VERSUS, isso foi feito separando em duas impressoes seguidas, onde na primeira eh impresso snake e na proxima eh inserido "versus" logo abaixo 
	
	mov edx, 0Fh;										//Cor inicial dos caracteres a serem impressos pela funcao de transformacao
	push edx
	mov edx, OFFSET Snake;								//Endereco do desenho eh um dos parametros da funcao de transformacao
	push edx

	call transformaImpressao;							//Essa funcao efetua a transformacao dos valores da variavel Snake (definida em .data) para o vetor de caracteres a serem printados na tela

	INVOKE PlaySound, OFFSET colisao, NULL, SND_ASYNC

	mov  eax, 700;										// Delay somente para tocar o som
	call Delay

	mov edx, 0Fh
	push edx
	mov edx, OFFSET Versus
	push edx
	call transformaImpressao
	INVOKE PlaySound, OFFSET colisao, NULL, SND_ASYNC

	mov  eax, 700;										// Delay para nao cortar o som
	call Delay

	INVOKE PlaySound, OFFSET musicaFundo, NULL, SND_LOOPASYNC;	//Musica do menu principal, a mesma ira se repetir assim que terminar ate que o jogo seja iniciado

	L1 :

	call alteraCores;									//Funcao responsavel por alterar a cor dos caracteres presentes na tela
	mov  eax, 635;										// Este delay eh somente para ter um controle da taxa de atualizacao das cores da tela
	call Delay
	call ReadKey
	jz   L1

	cmp dx, 20h
	je fim
	cmp dx, 50h
	je L2
	cmp dx, 070h
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

;// Esta eh a funcao principal do jogo, a mesma eh responsavel por desenhar os caracteres dos jogadores na tela e atualiza-los a partir dos valores
;//lidos das teclas de direcao que forem pressionadas

iniciaMovimentacao PROC

	ANIMATION :
	mov esi, OFFSET jogador1;									//cada jogador possui sua estrutura com seus dados de movimentacao, posicao e cores 
	call DESENHACARACTERE;										//a funcao de desenhar os caracteres na tela tem como parametro o endereco da posicao inicial da estrutura do jogador a ser desenhado

	mov esi, OFFSET jogador2
	call DESENHACARACTERE

	mov  eax, VELOC;											//Velocidade do jogo escolhida pelo jogador eh passada para eax que eh o registrador utilizado pelo delay
	call Delay;													//A velocidade do jogo eh definidi pela velocidade de atualizacao da tea
	call ReadKey
	jz   ANIMATION; 											//Se nenhuma tecla for pressionada o jogo continua a se atualizar e os jogadores permanecem se movimentando na mesma direcao


	;//#################################### VERIFICACAO MOVIMENTACAO JOGADOR 1 ####################################

	;// Abaixo seguem verificacoes das teclas de direcao, se alguma destas for pressionada entao eh chamada sua respectiva funcao de alteracao na direcao do jogador
	
	moveA:
	cmp dx, 'A';												//Caso for pressionado "A" o jogador 1 deve comecar a se movimentar para a esquerda
	jne moveD
	mov esi, OFFSET jogador1
	call MOVE_ESQUERDA;											//A funcao MOVE_ESQUERDA sera responsavel por alterar a direcao na qual o jogador esta indo, 
	;//neste caso para a esquerda, ela possui como parametro o endereco da estrutura do jogador a se mover para a esquerda
	jmp ANIMATION;												//Assim que a direcao do jogador tiver sido atualizada o loop se inicia novamente para imprimir as novas posicoes e ler uma nova tecla

	moveD :
	cmp dx, 'D'
	jne moveS
	mov esi, OFFSET jogador1
	call MOVE_DIREITA
	jmp ANIMATION

	moveS :
	cmp dx, 'S'
	jne moveW
	mov esi, OFFSET jogador1
	call MOVE_BAIXO
	jmp ANIMATION

	moveW :
	cmp dx, 'W'
	jne moveI
	mov esi, OFFSET jogador1
	call MOVE_CIMA
	jmp ANIMATION


	;//################## VERIFICACAO MOVIMENTACAO JOGADOR 2 ##################//

	moveI:
	cmp dx, 'I'
	jne moveJ
	mov esi, OFFSET jogador2
	call MOVE_CIMA
	jmp ANIMATION

	moveJ :
	cmp dx, 'J'
	jne moveL
	mov esi, OFFSET jogador2
	call MOVE_ESQUERDA
	jmp ANIMATION

	moveL :
	cmp dx, 'L'
	jne moveK
	mov esi, OFFSET jogador2
	call MOVE_DIREITA
	jmp ANIMATION

	moveK :
	cmp dx, 'K'
	jne ANIMATION
	mov esi, OFFSET jogador2
	call MOVE_BAIXO
	jmp ANIMATION

iniciaMovimentacao ENDP

;//################## PROCEDIMENTOS DE CONTROLE DA MOVIMENTACAO JOGADOR 1 e 2 ##################//

;// Toda vez que eh apertado algum botao de movimentacao alguma das funcoes abaixo sera chamada para setar o valor de quanto se deve somar em X e 
;// quanto se deve somar em Y para que o objeto(jogador) se mova na direcao desejada

somMover PROC
	INVOKE PlaySound, OFFSET mover, NULL, SND_ASYNC
	ret
somMover ENDP

MOVE_ESQUERDA PROC

	mov eax, SDWORD PTR[esi + 12];  								// SomadorX do jogador em questao
	cmp eax, -1;													// comparando somador X com -1, o jogador nao deve pressionar para permanecer na mesma direcao na qual ja esta indo
	jne semTrapaca;													// caso o jogador pressione para ir na mesma direcao na qual ja estava indo isso sera tratado como trapaca no jogo para atrapalhar a obtencao da tecla do outro jogador
	mov SDWORD PTR[esi + 12], 1	;									// no caso de trapaca entao o jogador eh direcionado automaticamente para uma direcao na qual ira colidir e perder o jogo
	jmp fim

	semTrapaca :
	mov SDWORD PTR[esi + 12], -1;									// Alterando valor do somador em X apartir do endereco da estrutura do jogador em questoa
	mov SDWORD PTR[esi + 16], 0;									// Zerando o somador em Y
	call somMover

	fim :
ret

MOVE_ESQUERDA ENDP

;// As demais direcoes possiveis para se movimentar seguem o mesmo padrao que a explicada acima, somente alterando o valor de X e Y dependendo da direcao a ser seguida

MOVE_DIREITA PROC

	mov eax, SDWORD PTR[esi + 12]
	cmp eax, 1
	jne semTrapaca
	mov SDWORD PTR[esi + 12], -1
	jmp fim

	semTrapaca :
	mov SDWORD PTR[esi + 12], 1
	mov SDWORD PTR[esi + 16], 0
	call somMover

	fim :
	ret

MOVE_DIREITA ENDP


MOVE_BAIXO PROC

	mov eax, SDWORD PTR[esi + 16]
	cmp eax, 1
	jne semTrapaca
	mov SDWORD PTR[esi + 16], -1
	jmp fim

	semTrapaca :
	mov SDWORD PTR[esi + 16], 1
	mov SDWORD PTR[esi + 12], 0
	call somMover

	fim :
	ret
	
MOVE_BAIXO ENDP

MOVE_CIMA PROC

	mov eax, SDWORD PTR[esi + 16]
	cmp eax, -1
	jne semTrapaca
	mov SDWORD PTR[esi + 16], 1
	jmp fim

	semTrapaca :
	mov SDWORD PTR[esi + 16], -1
	mov SDWORD PTR[esi + 12], 0
	call somMover

	fim :
	ret

MOVE_CIMA ENDP

;//################## PROCEDIMENTO QUE EFETUA A INCERCAO DE CARACTERES NA TELA ##################//

DESENHACARACTERE PROC USES ecx

	;// A estrutura ATRIBUTOJOGADOR é utilizada para a funcao de desenhar verificar onde cada objeto do jogo sera impresso (e suas caracteristicas), 
	;// portanto eh apontado o inicio dela no registrador ESI (isso para cada jogador no momento em que for ser atualizado na tela)
	;// para que seja possivel ler os valores dos atributos do jogador (com auxilio de indices) e entao inserir na estrutura da tela

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
	mov bx, WORD PTR[esi];									// Obtendo tipo do caractere a ser impresso
	mov eax, SDWORD PTR[esi + 12]; 							// SomadorX do objeto
	add[esi + 4], eax;										// NOVA PosicaoX dada pela posicao X anterior + o valor do somador X
	mov eax, SDWORD PTR[esi + 16]; 							// Somador Y
	add[esi + 8], eax;										// NOVA Posicao Y dada pela posicao Y anterior + o valor do somador Y



	mov eax, [esi + 8];   									// Passando a posicao Y para eax
	mov edx, COLS;											//Obtendo o numero de colunas em edx
	mul edx; 												//multiplica edx com eax e coloca o resultado em eax.Ele multiplica pois para chegar na linha Y, eh necessario andar no vetor buffer a seguinte quantidade: posicao Y*tamanho da linha(numero de colunas)
	add eax, [esi + 4];    									//Somando em eax (que neste momento possui o valor multiplicado de Y com a quantidade de elmentos por linha) o valor da posicao X

	call verificaColisao;									//para verificar se na posicao em que sera impresso ja possui algum caractere

	mov buffer[eax * atributosCaracteres].Char, bx; 		//posicao no vetor * tamanho de cada variavel
	mov bx, WORD PTR[esi + 2];   							//obtendo cor do caractere
	mov buffer[eax * atributosCaracteres].Atributos, bx;	//inserindo cor do caractere a ser impresso no vetor de caracteres
	invoke WriteConsoleOutput, console,					
	ADDR buffer, bufferSize, bufferCoord, ADDR region;		//funcao responsavel pela impressao do vetor de caracteres(buffer) na tela

ret

DESENHACARACTERE ENDP

;//################## FUNCOES DE COLISAO ##################// 


verificaColisao PROC

;//Funcao responsavel pela verificacao se na posicao em que sera impresso algo possui ou nao algo previamente desenhado
	
	cmp buffer[eax * atributosCaracteres].Char, ' '
	jne COLIDIU;											//COLIDIU eh um jump global que esta no main principal e eh chamado assim que alguem colidir parando entao a execucao do jogo

ret
verificaColisao ENDP


houveColisao PROC

;//No momento em que esta funcao eh chamada ja se sabe que alguem colidiu, somente eh verificado agora quem foi o jogador que colidiu, a funcao recebe como parametro o registrador esi

	INVOKE PlaySound, OFFSET colisao, NULL, SND_ASYNC
	mov  eax, 700;											// Delay do jogo no momento em que alguem colidir
	call Delay
	call ClearBuffer
		
	cmp esi, OFFSET jogador1;								//Verifica se o registrador esi estah apontando para a estrutura do jogador1, se estiver entao ele que colidiu			
	je jogador1bateu

	jogador2bateu :;										// Caso o jogador 2 tenha patido entao sera impresso a imagem que o jogador 1 vencedor
	push 0fh;												// Cor inicial a ser printada
	push OFFSET jogador1Vencedor	
	call transformaImpressao
	jmp fimPartida
	
	jogador1bateu :;										// Caso o jogador 1 tenha patido entao sera impresso a imagem que o jogador 2 vencedor
	push 0fh;												// Cor inicial a ser printada
	push OFFSET jogador2Vencedor
	call transformaImpressao

	fimPartida :
ret
houveColisao ENDP


;//################## IMPRESSAO MOLDURA JOGO ##################// 

printMoldura PROC

;//Essa funcao eh responsavel pela insercao da moldura de limitacao na tela no vetor(buffer) de caracteres da tela, ela faz uso da funcao de transformacao do desenho definido em .data para o vetor de caracteres

	mov edx, 04h;											//Cor a ser impressos os caracteres
	push edx
	mov edx, OFFSET molduraStatica;							//Endereco do desenho a ser transformado
	push edx
	call transformaImpressao
	
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

reinicializaJogadores PROC

	;//Uma vez que uma partida tiver sido terminada e uma nova for se iniciar eh necessario que as posicoes e as direcoes dos jogadores sejam resetadas
	;//para aquelas iniciais. Essa funcao eh responsavel por essa alteracao


	mov jogador1.posicaox, 1;									//o jogador1 inicia ao lado esquerdo da tela e o 2 ao lado direito
	mov jogador2.posicaox, COLS - 2
	mov jogador1.posicaoy, ROWS / 2;							//Os jogadores iniciam na metade da tela
	mov jogador2.posicaoy, ROWS / 2
	mov jogador1.somadorx, 1;									// O jogador 1 deve ir para a direita e o jogador2 deve ir para a esquerda assim que o jogo iniciar				
	mov jogador2.somadorx, -1
	mov jogador1.somadory, 0
	mov jogador2.somadory, 0

ret
reinicializaJogadores ENDP

;//################## FUNCAO DE TRANSFORMACAO DA IMAGEM PARA O BUFFER

transformaImpressao PROC

	;// Funcao responsavel por transformar imagens previamente criadas no .data para o vetor buffer
	;//que sera o responsavel pela impressao das mesmas, a funcao possui como parametros a cor do desenho a ser impresso e o endereco do desenho a ser transformado

	push ebp
	mov ebp, esp

	mov eax, ultimaPosBuffer;									// endereco no qual devera estar apontando a proxima posicao que algo sera impresso no buffer, alguns elementos no jogo sao impressos posteriormente e assim nao ficam no topo da tela, como por exemplo no menu inicial quando eh escrito SNAKE e depois VERSUS
	mov edx, 0
	mov ecx, DWORD PTR[ebp + 8];								//apontando para o endereco da variavel que possui oque sera escrito

	insereLinha:

	movzx ebx, BYTE PTR[ecx + edx];								//apontando para o endereco do proximo char a ser passado para o buffer
	cmp ebx, 0;													//Todos os desenhos sao terminados com "0" para sabermos onde o mesmo encerra
	je fimDesenho
	
	cmp ebx, 0ah;												//verificando se eh um espaco em branco no desenho
	je proxChar
	cmp ebx, '#';												//caso seja o caracter # o mesmo serah substituido por um outro
	jne naoAltera
	mov bx, 0DBh

	naoAltera : ;												//Caso o caracter seja diferente de # entao ele mesmo que sera passado para o vetor de caracteres da tela
	mov buffer[eax * atributosCaracteres].Char, bx
	mov bx, WORD PTR[ebp + 12]
	mov buffer[eax * atributosCaracteres].Atributos,bx;			//Definindo a cor do caractere em questao


	proxChar:;													//Incrementando os indices para acessar a proxima posicao da tela e do desenho na proxma iteracao do loop
	inc eax
	inc edx
	jmp insereLinha
		
	fimDesenho:
	mov ultimaPosBuffer, eax
	invoke WriteConsoleOutput, console,
	ADDR buffer, bufferSize, bufferCoord, ADDR region;			//Impressao do vetor de caracteres na tela

	pop ebp
	ret 8
transformaImpressao ENDP
;//################## FUNCAO DE ALTERACAO DE CORES


alteraCores PROC

	;//Essa eh a funcao responsavel por fazer com que as cores do conteudo da tela fiquem mudando na tela de menu e a tela de exibicao do vencedor
	
	mov dx, 0
	mov eax, 0

	proximoCaractere:

	mov buffer[eax * atributosCaracteres].Atributos, dx;		//Aqui eh definida a cor do caractere atual, todos os caracteres da tela sao alterados
	naoAltera :
	inc eax
	add cores, 1
	mov dl, cores;												//dl contem a cor do caractere
	and dx, 00001111b;											//O atributo da cor do caracter possui 1byte mas a parte alta e a parte baixa controlam o fundo e a cor do caractere reespectivamente, nos somente vamos alterar a cor do caractere, devido a isso fazemos um and para deixar preto o fundo
	cmp eax, COLS*ROWS;											//Verifica se ja percorreu o tamanho equivalente ao tamanho da tela

	jb proximoCaractere

	invoke WriteConsoleOutput, console,
	ADDR buffer, bufferSize, bufferCoord, ADDR region;			//Impressao da tela apos alteradas todas cores

	ret
alteraCores ENDP

END main