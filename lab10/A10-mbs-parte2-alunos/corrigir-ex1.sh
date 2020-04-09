#!/bin/bash

# ------------------------------------------------------------------
# PARTE 1: setup

# Aborta o script em caso de erro.
set -e

# Diretório em que este script está.
SELFDIR=$( cd "$(dirname "$0")" ; pwd -P )

# Caso o script tenha sido chamado de outro diretório, vai até
# o diretório do script.
cd ${SELFDIR}

# Importa arquivo com funções auxiliares
source 'utils.sh'

# ------------------------------------------------------------------

p_info '-------------------------------------------------------------------'
p_info 'Correção do Exercício 1 (Aula 10 - Monitor Batch - Parte II)'
p_info '-------------------------------------------------------------------'

# Apaga e recria os diretórios e arquivos usados pelo corretor.
rm -rf .ex1
mkdir .ex1

if [[ "$MBS_SOURCE_DIR" = "" ]]; then
  MBS_SOURCE_DIR="$SELFDIR/mbs-source"
fi

# Verifica se o diretório com o código-fonte existe.

if [[ -d "$MBS_SOURCE_DIR" ]]; then
  p_ok "[Ok] Diretório com o código-fonte do MBS existe"
else
  p_err "[erro] Diretório com o código-fonte do MBS não existe: $MBS_SOURCE_DIR"
  exit 1
fi

(
  cd $MBS_SOURCE_DIR &&
  rm -f dumper.lst dumper.mvn loader.lst loader.mvn main.lst main.mvn main-absoluto.mvn main-relocavel.mvn
)

# Monta cada arquivo individualmente
echo "$MBS_SOURCE_DIR/dumper.asm" | java -cp mlr.jar montador.MvnAsm
echo "$MBS_SOURCE_DIR/loader.asm" | java -cp mlr.jar montador.MvnAsm
echo "$MBS_SOURCE_DIR/main.asm"   | java -cp mlr.jar montador.MvnAsm

# Liga os arquivos
java -cp mlr.jar linker.MvnLinker $MBS_SOURCE_DIR/main.mvn $MBS_SOURCE_DIR/dumper.mvn $MBS_SOURCE_DIR/loader.mvn -s $MBS_SOURCE_DIR/main-relocavel.mvn

# Reloca
java -cp mlr.jar relocator.MvnRelocator $MBS_SOURCE_DIR/main-relocavel.mvn $MBS_SOURCE_DIR/main-absoluto.mvn 0000

# -------------------------------------------------------------------
# Executa teste de LO e EX na MVN
# -------------------------------------------------------------------

mvn_cmd='java -jar mvn.jar'

set +e

echo -e "
i
s

p $MBS_SOURCE_DIR/main-absoluto.mvn
p mbs_clean.mvn
r 0000 s n
m 0700 0711 .ex1/mbs_test_lo_ex.mem
x" | ${mvn_cmd} | tee $SELFDIR/.ex2/mbs_test_lo_ex.stdout

ruby verifica-ex1.rb