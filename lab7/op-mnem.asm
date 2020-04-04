  JP START

@ /020 ; Tabela de mnemônicos
TABLE     K /4A50 ; JP
          K /4A5A ; JZ
          K /4A4E ; JN
          K /4C56 ; LV
          K /2B20 ; +
          K /2D20 ; -
          K /2A20 ; *
          K /2F20 ; /
LOAD_MNEM K /4C44 ; LD
          K /4D4D ; MM
          K /5343 ; SC
          K /5253 ; RS
          K /484D ; HM
          K /4744 ; GD
          K /5044 ; PD
          K /4F53 ; OS

@ /010
OPCODE   K /001
MNEM     K /4A5A
UM       K =1
DOIS     K =10
LOAD     LD /000
P_TABLE  K  TABLE
ITERADOR K  /000

@ /100 ; OP2MNEM
OP2MNEM JP CHAMADA_OP2MNEM
      LD OPCODE
      *  DOIS
      +  P_TABLE
      +  LOAD
      MM INST1
INST1 K  /0000
      MM MNEM
      RS OP2MNEM

@ /200 ; MNEM2OP
MNEM2OP JP CHAMADA_MNEM2OP
BEG_LOOP LD ITERADOR
      +  DOIS
      MM ITERADOR
      -  DOIS
      +  P_TABLE
      +  LOAD
      MM INST2
INST2 K  /000
          -  MNEM
          JZ END_LOOP ; Achou a instrução certa
          JP BEG_LOOP ; Completa o loop
END_LOOP LD ITERADOR
         -  DOIS
         /  DOIS ; Transforma o valor (iterador inicial) no OPCODE posicional
         MM OPCODE
         RS MNEM2OP

@ /300 ; Programa principal
START LV /007
      MM OPCODE
CHAMADA_OP2MNEM  SC OP2MNEM
      LD MNEM
      PD /100 ; Imprime o MNEM

      LD LOAD_MNEM
      MM MNEM
CHAMADA_MNEM2OP  SC MNEM2OP
      LD OPCODE
      PD /100 ; Impriem OPCODE

END   HM END

# START
