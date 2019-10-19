#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>


//so pode usar wait com mutex travado
long contador = 0; 
pthread_mutex_t mymutex = PTHREAD_MUTEX_INITIALIZER;//estatico
//dinamico: pthread_mutex_init(&mymutex, NULL); -> tem q desalocar qdo n quiser usar mais

void *inc(void *threadid){
    int i;
    for(i = 0; i < 900000; i++) { 
        while(pthread_mutex_trylock(&mymutex)!=0);//espera ocupada, o outro comando eh melhor
        contador++; 
        pthread_mutex_unlock(&mymutex); //destrava
    }
}

void *dec(void *threadid){   
    int i;
    for(i = 0; i < 900000; i++) { 
        pthread_mutex_lock(&mymutex);//trava 
        contador--; 
        pthread_mutex_unlock(&mymutex); //destrava
    }
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
