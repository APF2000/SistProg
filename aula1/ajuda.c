#include <stdio.h>
#define SIZE 100

int main(){

  char buffer[SIZE];
  int i;

  scanf("%[^\n]%*c", buffer);
  while(buffer[0] != '\t'){
    printf("\n");
    for(i=0; buffer[i] != '\0'; i++){
      if(i >= 7)
        printf("%c", buffer[i]);
    }
    scanf("%[^\n]%*c", buffer);
  }

  return 0;
}
