#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

long contador = 0; 

void *inc(void *threadid){
  int i; 
  for(i = 0; i < 90000; i++) contador++; 
}

void *dec(void *threadid){   
  int i;
  for(i = 0; i < 90000; i++) contador--; 
}

int main (int argc, char *argv[]){   
  pthread_t thread1, thread2;   
  pthread_create(&thread1, NULL, inc, NULL); 
  pthread_create(&thread2, NULL, dec, NULL); 
  pthread_join(thread1, NULL);
  pthread_join(thread2, NULL); 
  printf("Valor final do contador: %ld\n", contador);
  pthread_exit(NULL);
}
