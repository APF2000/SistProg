; -------------------------------------------------------------------
; Programa principal do Monitor Batch Simples (MBS)
; -------------------------------------------------------------------

; Coloque aqui os símbolos importados

DUMPER          <
DUMP_INI        <
DUMP_TAM        <
DUMP_UL         <
DUMP_BL         <
DUMP_EXE        <

LOADER      <
LOADER_UL   <
; -------------------------------------------------------------------

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
EIGHT           K       /1000
FOUR            K       /0100
TWO             K       /0010

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
  ;; Valor da resposta está no acumulador!
CH_RET          RS      CHTOI


; ==================================================================

INI             JP       COMECA

BARRAS		K	'//
JOB		K	'JB
FIMCHAR	K	'/*
ENTER		K	/0A0A
ESPACO		K	/2020
DUMP		K	'DU
LOAD		K	'LO
ACAO		K	/0000
X1		K	/0000
X0		K	/0000

COMECA		GD 	/300
		-	BARRAS
		JZ	JOBOK1/3
		JP	JOBERRO	;ADICIONAR JOBERRO
JOBOK1/3	GD	/300
		-	JOB
		JZ	JOBOK2/3
		JP	JOBERRO
JOBOK2/3	GD	/300
		-	ENTER
		JZ	JOBOK3/3
		JP	JOBERRO
JOBOK3/3	GD	/300
		-	BARRAS
		JZ	CMDOK1/3
		JP	CMDERRO
CMDOK1/3	GD	/300
		MM	ACAO
		JP	CMDOK2/3
CMDOK2/3	GD	/300
		-	ENTER
		JZ	CMDOK3/3
		JP	CMDERRO
CMDOK3/3	LD	ACAO		;VERIFICA O COMANDO SELECIONADO
		-	LOAD
		JZ	LOAD_ACAO
		+	LOAD
		-	DUMP
		JZ	DUMP_ACAO
		JP	CMDERRO	;ADICIONAR CMDERRO

LOAD_ACAO	SC	LENUMERO
		MM	LOADER_UL
		SC	LOADER
		JP	FIMACAO

DUMP_ACAO	SC	LENUMERO
		MM	DUMP_BL
		GD	/300
		-	ESPACO
		JZ	DUMP_ACAO_OK1
		JP	ERROARG	;ADICIONAR ERROARG
DUMP_ACAO_OK1	SC	LENUMERO
		MM	DUMP_INI
		GD	/300
		-	ESPACO
		JZ	DUMP_ACAO_OK2
		JP	ERROARG
DUMP_ACAO_OK2	SC	LENUMERO
		MM	DUMP_TAM
		GD	/300
		-	ESPACO
		JZ	DUMP_ACAO_OK3
		JP	ERROARG
DUMP_ACAO_OK3	SC	LENUMERO
		MM	DUMP_EXE
		GD	/300
		-	ESPACO
		JZ	DUMP_ACAO_OK4
		JP	ERROARG
DUMP_ACAO_OK4	SC	LENUMERO
		MM	DUMP_UL
		GD	/300
		-	ENTER
		JZ	DUMP_ACAO_OK5
		JP	ERROARG
DUMP_ACAO_OK5	SC	DUMPER	
		JP	FIMACAO

FIMACAO	GD	/300
		-	ENTER
		JZ	ERROARG	;IMPLEMENTAR ERROARG
		GD	/300
		-	FIMCHAR
		JZ	FINALOK
		JP	ERROEND	;IMPLEMENTAR ERROEND

FINALOK	LV	/0000
		JP	VERIFICA

JOBERRO	LV	/0001
		JP	VERIFICA

CMDERRO	LV	/0002
		JP	VERIFICA

ERROARG	LV	/0003
		JP	VERIFICA

ERROEND	LV	/0004
		JP	VERIFICA

VERIFICA	OS	/00EE
		JP	FIM


LENUMERO	K	/0000
		GD	/300
		MM	CH_IN_A
		GD	/300
		MM	CH_IN_B
		SC	CHTOI
		RS	LENUMERO

; ==================================================================

FIM             HM      FIM   ; Fim do programa

# MAIN
