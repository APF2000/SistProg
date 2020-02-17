@ start
X K 0003
Y K 0004
Z K 0005

resp K 0000
hip K 0000
cat1 K 0000
cat2 K 0000
aux K 0000

/////////////////
sort  K /0000
LD  X
-   Y
JN  ygtx
LD  X
MM  hip
LD  Y
MM  cat1
JP  cont2
LD  X
MM  cat1
LD  Y
MM  cat1
LD  X
MM  cat1
LD  Y
MM  hip

cont1 LD hip
-   Z
JN  zgtx
LD  Z
MM  cat2
JP  cont2

ZGTH  LD  hip
MM  cat2
LD  Z
MM hip

cont2 RS sort
//////////////
istriangle K /0000
LD cat1
+   cat2
-   hip
JZ  nottriangle
JN  nottriangle

LV  K 0001
JP  fimtriangle
nottriangle LV  K 0000
fim RS  fimtriangle



start SC sort
