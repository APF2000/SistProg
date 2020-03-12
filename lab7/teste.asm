; ----------------------------------------------------------------------------
; Exemplo de programa escrito na linguagem de montagem da MVN
; Refer�ncia da linguagem:
; Slides das aulas 10 e 11
; ----------------------------------------------------------------------------

    JP INICIO      ; Jump incondicional para o in�cio

@   /100           ; Define que o endere�o agora �: 0x100
C0  K  /100        ; Declara uma constante chamada C0 com valor 0x100
C1  K  /111        ; Declara outra constante, e etc.
C2  K  /122
CB  K  /1BB
CC  K  /1CC
CD  K  /1DD
CE  K  /1EE
CF  K  /1FF


; Exemplos de declara��o de constantes em diferentes formatos:

GG  K  'ER         ; Base 256 (valor = 'E'*256^1 + 'R'*256^0)
GH  K  'RO         ; Base 256
GJ  K  =1000       ; Base 10 (1000 em decimal)
GK  K  /3E8        ; Base 16 (equivalente a 0x3E8)
GL  K  @1750       ; Base 8
GM  K  #1111101000 ; Base 2 (1111101000 em bin�rio)

@   /200           ; Define que o endere�o agora �: 0x200
$   /A             ; Reserva 10 words

TRES K /4142

TESTANDO K /4344

INICIO JP INI       ; Comeco do programa

INI    LD TRES
       PD /301
       LD TESTANDO
       PD /301

       HM CC

       JZ C1       ; Exemplo de uso de todos os mnemonicos da linguagem
       JN C2


       LD TESTANDO
       PD /100

       HM CC

       GD CD
       PD CE
       OS CF

# INICIO           ; Marca o final do programa
