    JP START      ; Jump incondicional para o in�cio


COUNTS_END K /0000  ; unidade logica do arquivo-texto
COUNTS_UL  K /0000  ; diz qual a unidade logica (ordinal)
READ K /E000

COUNTS K /0000

READER JP /0000

       GD /0000 ; comando para ler do disco (montado)
       RS COUNTS


;
;Arthur Pires da Fonseca - 10773096
;

; =============================================================================
;
; *** SIMBOLOS IMPORTADOS
; ... <
;
					&	/0000
MAIN				JP	START

; RETORNO DE COUNTS
RESULTADO			K	/0000

; VALORES FORNECIDOS
UL					K	/0001			; NUMERO DA UNIDADE LOGICA

; STRING A SER PROCURADA, INCLUINDO EOS (i.e., 0000)
STRPROC		K	/414C	; "ALO GALERA DO CAUBOI\0"
					K	/5520
					K	/4741
					K	/4C45
					K	/5241
					K	/2044
					K	/4F20
					K	/4341
          K /5542
          K /4F49
          K /0000

; CORPO DO MAIN
START			LV	STRPROC
					MM	COUNTS_END		; PARAM 1: ENDERECO DA STRING A SER PROCURADA
					LD	UL
					MM	COUNTS_UL			; PARAM 2: UNIDADE LOGICA DO ARQUIVO

					SC	COUNTS				; INVOCA COUNTS
					MM	RESULTADO			; SALVA O RESULTADO
;
FIM					HM	FIM					; FIM DO MAIN
;
;


					# 	MAIN
