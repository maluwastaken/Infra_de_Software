#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

long contador = 0;
pthread_mutex_t mymutex = PTHREAD_MUTEX_INITIALIZER;
bool done = true;

void *inc(void *threadid){
  long *tid = (long *)threadid;
  while(done){
    pthread_mutex_lock(&mymutex);
    if(contador == 1000000 ) {
      if(done){
        printf("Valor final do contador: %ld, finalizado na thread %ld\n", contador, *tid);
        done = false;
      }
      pthread_mutex_unlock(&mymutex);
      pthread_exit(NULL);
    }
    contador++;
    pthread_mutex_unlock(&mymutex);
  }
  pthread_exit(NULL);
}

int main (int argc, char *argv[]){
	long n;
	scanf("%ld", &n);
	pthread_t threads[n];
	long *taskids[n];
	void *status;
	int rc, t, i;
	for(t=0; t<n; t++){
		taskids[t] = (long *) malloc(sizeof(long)); *taskids[t] = t;
		rc = pthread_create(&threads[t], NULL, inc, (void *) taskids[t]);
		if (rc){
			printf("ERRO; código de retorno é %d\n", rc);
			exit(-1);
		}
	}
  for(i=0; i<n; i++)
    pthread_join(threads[i], &status);
    pthread_mutex_destroy(&mymutex);
    pthread_exit(NULL);
	return 0;
}
