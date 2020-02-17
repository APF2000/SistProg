#include <stdio.h>

int fatorial(int n);

/**
 * Ponto de entrada do programa (entry point).
 */
int main(int argc, char** argv) {
  int n;
  scanf("%d", &n);

  printf("%d\n", fatorial(n));

  return 0;
}

/**
 * Calcula o fatorial do número recebido e retorna o resultado.
 */
int fatorial(int n) {
  int i, fat=1;
  for(i=1; i <= n; i++){
    fat *= i;
  }
  return fat;
}
