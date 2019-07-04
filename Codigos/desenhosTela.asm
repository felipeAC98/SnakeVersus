.data

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
	byte'                    ATENCAO, NAO EH PERMITIDO PRESSIONAR DUAS VEZES                  ', 0ah
	byte'                             UMA TECLA PARA A MESMA DIRECAO!                         ', 0ah
	byte'                                                                                     ', 0ah
	byte'                                                                                     ', 0ah
	byte'                       Jogador 1                        Jogador 2                    ', 0ah
	byte'                          ____                             ____                      ', 0ah
	byte'                         ||W ||                           ||I ||                     ', 0ah
	byte'                     ____||__||____                   ____||__||___                  ', 0ah
	byte'                    ||A |||S |||D ||                 ||J |||K |||L ||                ', 0ah
	byte'                    ||__|||__|||__||                 ||__|||__|||__||                ', 0ah
	byte'                    |/__\|/__\|/__\|                 |/__\|/__\|/__\|                ', 0ah
	byte'                                                                                     ', 0ah
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


	jogador2Vencedor     byte'                                                                                                    '
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




