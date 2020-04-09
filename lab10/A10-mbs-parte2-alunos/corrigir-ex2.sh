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
p_info 'Correção do Exercício 2 (Aula 10 - Monitor Batch - Parte II)'
p_info '-------------------------------------------------------------------'

if [[ "$MVN_SOURCE_DIR" = "" ]]; then
  MVN_SOURCE_DIR="$SELFDIR/mvn-source"
fi

# Verifica se o diretório com o código-fonte existe.

if [[ -d "${MVN_SOURCE_DIR}" ]]; then
  p_ok "[Ok] Diretório com o código-fonte da MVN existe"
else
  p_err "[erro] Diretório com o código-fonte da MVN não existe: $MVN_SOURCE_DIR"
  exit 1
fi

# Apaga o diretório com arquivos de execuções anteriores do corretor.
rm -rf .ex2

mkdir .ex2
unzip -d .ex2 'mvn-source.zip'

# Copia os arquivos modificados no exercício.
cp "$MVN_SOURCE_DIR/src/mvn/controle/PainelControle.java" ".ex2/mvn-source/src/mvn/controle/"
cp "$MVN_SOURCE_DIR/src/mvn/MvnControle.java" ".ex2/mvn-source/src/mvn/"
cp "$MVN_SOURCE_DIR/src/mvn/MvnPcs.java" ".ex2/mvn-source/src/mvn/"
cp "$MVN_SOURCE_DIR/src/mvn/UnidadeControle.java" ".ex2/mvn-source/src/mvn/"

# -------------------------------------------------------------------
# Compilação do projeto

set +e

echo -e "${COLOR_YELLOW}"
( cd .ex2/mvn-source && ant compile )
return_code=$?
echo -e "${COLOR_END}"

if [[ $return_code -ne 0 ]]; then
  p_err '[erro] Não foi possível compilar o projeto.'
  p_err 'Nota: 0.000'
  exit 1
else
  p_ok "[Ok] Projeto compilado com sucesso."
fi

set -e
# -------------------------------------------------------------------

p_info "\nExecutando a MVN com o programa de exemplo..."

# Execução dos testes (Java)

echo -e "${COLOR_YELLOW}"

cd .ex2/mvn-source/build

echo -e "
p ../../../os_0ef_test.mvn
r 0000 s n
m 0000 002F ../../../.ex2/os_0ef_test.mem
x" | java -cp . mvn.MvnPcs | tee $SELFDIR/.ex2/os_0ef_test.stdout

echo -e "${COLOR_END}"

cd $SELFDIR

# Compara .ex2/os_0ef_test.mem ||| correcao/os_0ef_test_0.ref

# -------------------------------------------------------------------
# Testes de exibição do valor dos registradores e execução passo-a-passo
# -------------------------------------------------------------------

echo -e "${COLOR_YELLOW}"

cd .ex2/mvn-source/build

echo -e "
p ../../../os_0ef_test.mvn
r 0000 n n
m 0000 002F ../../../.ex2/os_0ef_test_case_00.mem
x" | java -cp . mvn.MvnPcs | tee $SELFDIR/.ex2/os_0ef_test_case_00.stdout

echo -e "${COLOR_END}"

cd $SELFDIR


# 8888888888888888888888888888888888888888888888888888888888888888

echo -e "${COLOR_YELLOW}"

cd .ex2/mvn-source/build

echo -e "
p ../../../os_0ef_test.mvn
r 0000 s n
m 0000 002F ../../../.ex2/os_0ef_test_case_10.mem
x" | java -cp . mvn.MvnPcs | tee $SELFDIR/.ex2/os_0ef_test_case_10.stdout

echo -e "${COLOR_END}"

cd $SELFDIR

# 8888888888888888888888888888888888888888888888888888888888888888

echo -e "${COLOR_YELLOW}"

cd .ex2/mvn-source/build

echo -e "
p ../../../os_0ef_test.mvn
r 0000 s s














m 0000 002F ../../../.ex2/os_0ef_test_case_11.mem
x" | java -cp . mvn.MvnPcs | tee $SELFDIR/.ex2/os_0ef_test_case_11.stdout

echo -e "${COLOR_END}"

cd $SELFDIR

ruby verifica-ex2.rb

