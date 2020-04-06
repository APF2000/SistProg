; -------------------------------------------------------------------
; Programa principal do Monitor Batch Simples (MBS)
; -------------------------------------------------------------------

; Coloque aqui os símbolos importados
; -------------------------------------------------------------------

LOADER      <
LOADER_LU   <

DUMPER          >
DUMP_INI        >
DUMP_TAM        >
DUMP_UL         >
DUMP_BL         >
DUMP_EXE        >

; ...

; Origem relocável
                &       /0000

MAIN            JP      INI      ; salta para o início do programa
UL              K       /0000    ; parâmetro: UL onde está o arquivo de batch

; -------------------------------------------------------------------
; Subrotina: UNPACK
; Extrai os bytes de uma word contida no acumulador, colocando-os
; em dois endereços da memória.
;
; Exemplo: dada a word XYZT no acumulador, ao final da execução,
; UNP_B1="00XY" e UNP_B2="00ZT".
; -------------------------------------------------------------------

; Parâmetros
WORD            $       /0001       ; Word de entrada
UNP_B1          $       /0001       ; Byte mais significativo
UNP_B2          $       /0001       ; Byte menos significativo

; Constantes
SHIFT           K       /0100
CH_0            K       /0030
CH_F            K       /0046
X_INI           K       /003A
X_END           K       /0041
X_DIFF          K       /0007
ONE             K       /0001
MINUS_1         K       /FFFF
ZERO            K       /0000
EIGHT           K       #1000
FOUR            K       #0100
TWO             K       #0010

; Corpo da subrotina
UNPACK          $       /0001
                MM      WORD        ; Carrega word. Primeiramente faremos unpack de B2
                *       SHIFT       ; Desloca os bytes para remover 2 primeiros hex
                SC      RSHIFT2     ; Desloca os bytes menos significativos pro seu lugar
                MM      UNP_B2      ; Salva resultado
                LD      WORD        ;
                SC      RSHIFT2     ;
                MM      UNP_B1      ;
                RS      UNPACK      ; Retorna

; -------------------------------------------------------------------
; Subrotina: RSHIFT2
; Faz um right shift (<) duas vezes do valor do acumulador
; -------------------------------------------------------------------

; Constantes
FIX             K       /8000
REFIX           K       /0080
; Corpo da subrotina
RSHIFT2         $       /0001
                JN      NEG         ; O número é negativo
                /       SHIFT       ; Retorna os 2 bytes à posição inicial
                JP      FIM-RS      ; Vai para final de RSHIFT2
NEG             -       FIX         ; Fix do shift em número negativo
                /       SHIFT       ; Shift
                +       REFIX       ; Fix para voltar número tirado
FIM-RS          RS      RSHIFT2     ; Retorno

; -------------------------------------------------------------------
; Subrotina: IS_HEX
; -------------------------------------------------------------------

  ;; Parâmetros
S_HEX           $       /0001
  ;; Corpo da subrotina
IS_HEX          $       /0001
                MM      S_HEX
  ;; Verifica se < '0'
                -       CH_0
                JN      NOT_HEX
  ;; Verifica se > 'f'
                LD      S_HEX
                -       CH_F
                -       ONE ; we wanna include 'f'
                JN      MIGHTB
  ;; Não é hex. Retorna -1.
NOT_HEX         LD      MINUS_1
                RS      IS_HEX
  ;; Incrementa CH_F decrementado e verifica se é caractere especial.
MIGHTB          LD      S_HEX
                -       X_INI
                JN      YES_HEX
                -       X_DIFF
                JN      NOT_HEX
                LD      S_HEX
                -       X_DIFF
                RS      IS_HEX
YES_HEX         LD      S_HEX
                RS      IS_HEX

; -------------------------------------------------------------------
; Subrotina: CHTOI
; Converte uma word em hexa para um número inteiro.
;
; Exemplo: CHTOI("0010") = 0010 (i.e., 16 em decimal)
; -------------------------------------------------------------------

  ;; Parâmetros
CH_ANS          $       /0001        ; Variável para guardar resultado
CH_IN_A         $       /0001        ; 2 bytes mais significativos (em ASCII)
CH_IN_B         $       /0001        ; 2 bytes menos signicativos (em ASCII)

  ;; Corpo da subrotina
CHTOI           $       /0001
  ;; Zera CH_ANS
                LD      ZERO
                MM      CH_ANS
  ;; Unpack primeira palavra
                LD      CH_IN_A
                MM      WORD
                SC      UNPACK
  ;; Processa primeira palavra
  ;; Processa primeiro byte
                LD      UNP_B1
                SC      IS_HEX
                JN      CH_RET
                -       CH_0
                *       EIGHT
                MM      CH_ANS
  ;; Processa segundo byte
                LD      UNP_B2
                SC      IS_HEX
                JN      CH_RET
                -       CH_0
                *       FOUR
                +       CH_ANS
                MM      CH_ANS
  ;; Unpack segunda palavra
                LD      CH_IN_B
                MM      WORD
                SC      UNPACK
  ;; Processa segunda palavra
  ;; Processa primeiro byte
                LD      UNP_B1
                SC      IS_HEX
                JN      CH_RET
                -       CH_0
                *       TWO
                +       CH_ANS
                MM      CH_ANS
  ;; Processa segundo byte
                LD      UNP_B2
                SC      IS_HEX
                JN      CH_RET
                -       CH_0
                +       CH_ANS
  ;; Valor da resposta está no acumulador! -> blz, obrigado
CH_RET          RS      CHTOI



INI             K       /0000

; ==================================================================
;                                                                   |
;                              AQUI                                 |
;                              VAI                                  |
;                               O                                   |
;                              SEU                                  |
;                              MBS!                                 |
;                                                                   |
;                               \o/                                 |
;                                                                   |
; ==================================================================

READ_NUM	$	/0001
		GD	/300
		MM	CH_IN_A ; in box
		GD	/300
		MM	CH_IN_B 

		SC	CHTOI

		RS	READ_NUM


BARRA_BARRA	K	'//	
JB		K	'JB
EOL		K	/0A0A
FIM_JOB		K	'/*
SPACE		K	/2020

LOAD		K	'LO
DUMP		K	'DU
AUX		$	/0001

		GD 	/300
		- 	BARRA_BARRA 	; //
		JZ	CONTINUE1
		JP	ERR:JOB
CONTINUE1	GD	/300
		- 	JB	    	; JB
		JZ	CONTINUE2
		JP	ERR:JOB
CONTINUE2	GD	/300
		- 	EOL	    	;\n
		JZ	LOOP
		JP	ERR:JOB


LOOP		GD	/300
		- 	BARRA_BARRA 	; //
		JZ	CONTINUE3
		JP	ERR:CMD

CONTINUE3	GD	/300
		MM	AUX
		-	LOAD
		JZ	FAZER_LOAD	; inst de load

		LD	AUX
		-	DUMP		
		JZ	FAZER_DUMP	; inst de dump

		JP	ERR:CMD

CONTINUE4	GD	/300
		-	FIM_JOB
		JZ	FIM
		JP	LOOP

;---------------------------------------------
; Lembrete 1
;LOADER      <
;LOADER_LU   <

FAZER_LOAD	GD	/300
		- 	EOL		; \n
		JZ	CONTINUE_LOAD1
		JP	ERR:CMD
CONTINUE_LOAD1	SC	READ_NUM
		MM	LOAD_UL
		GD	/300
		-	EOL		; \n
		JZ	CONTINUE_LOAD2
		JP	ERR:CMD
CONTINUE_LOAD2	SC	LOADER
		JP	CONTINUE4

;-------------------------------------------
; Lembrete 2
;DUMPER          >
;DUMP_BL         >
;DUMP_INI        > "<tamanho_bloco>bb<endereço_inicial>bb<tamanho_total>bb
;			<endereço_primeira_instrução>bb<LU>"
;DUMP_TAM        >
;DUMP_EXE        >
;DUMP_UL         >

FAZER_DUMP	GD	/300
		- 	EOL		; \n
		JZ	CONTINUE_DUMP1
		JP	ERR:ARG
CONTINUE_DUMP1	SC	READ_NUM
		MM	DUMP_BL
		GD	/300		; tam bloco
		-	SPACE
		JZ	CONTINUE_DUMP2
		JP	ERR:ARG
CONTINUE_DUMP2	SC	READ_NUM
		MM	DUMP_INI
		GD	/300		; end inicial
		-	SPACE
		JZ	CONTINUE_DUMP3
		JP	ERR:ARG
CONTINUE_DUMP3	SC	READ_NUM
		MM	DUMP_TAM
		GD	/300		; tam tot
		-	SPACE
		JZ	CONTINUE_DUMP4
		JP	ERR:ARG
CONTINUE_DUMP4	SC	READ_NUM
		MM	DUMP_EXE
		GD	/300		; end primeira inst
		-	SPACE
		JZ	CONTINUE_DUMP5
		JP	ERR:ARG
CONTINUE_DUMP5	SC	READ_NUM
		MM	DUMP_UL
		GD	/300		; unidade logica
		-	SPACE
		JZ	CONTINUE_DUMP6
		JP	ERR:ARG
		
CONTINUE_DUMP6	GD	/300
		- 	EOL		; \n
		JZ	CONTINUE_DUMP7
		JP	ERR:ARG

CONTINUE_DUMP7	SC	DUMPER
		JP	CONTINUE4
					
;-------------------------------------------	

ERR:JOB		LV	/0001
		JP	ANTE_FIM

ERR:CMD		LV	/0002
		JP	ANTE_FIM

ERR:ARG		LV	/0003
		JP	ANTE_FIM

ERR:END		LV	/0004
		JP	ANTE_FIM

;-------------------------------------------


ANTE_FIM	OS	/00EE

FIM             HM      FIM   ; Fim do programa


# MAIN
