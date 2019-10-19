#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <stdbool.h>
#define N 2
#define P 50

double a[N][N] = {7, 3, 3, -4};
int b[N] = {7, 4};
double x[N] = {1, 1};

pthread_barrier_t barrier;
pthread_mutex_t mymutex[N] = {PTHREAD_MUTEX_INITIALIZER, PTHREAD_MUTEX_INITIALIZER};

void *calculaX(void* threadid){
	int k = 0;double sum = 0, buff;
	long *tid = (long *)threadid;
	int j;
	while(k < P){
		sum = 0;
		pthread_mutex_lock(&mymutex[(*tid)]);
		for(j = 0; j < N; j++){
			if(j != (*tid))
				sum += (a[(*tid)][j] * x[j]);
		}
		x[(*tid)] = (1 /a[(*tid)][(*tid)] ) * (b[(*tid)] - sum);
		printf("k = %d, thread = %ld, x(%ld) = %lf\n\n", k, (*tid), (*tid)+1,x[(*tid)]);
		pthread_mutex_unlock(&mymutex[(*tid)]);
		pthread_barrier_wait(&barrier);
		k++;
	}
}

int main(){
	pthread_t threads[N];
	long *taskids[N];
	int rc, t;
	//for(t = 0; t < N; t++) mymutex[t] = PTHREAD_MUTEX_INITIALIZER;
	pthread_barrier_init(&barrier, NULL, N);
	for(t = 0; t < N; t++){
		taskids[t] = (long *) malloc(sizeof(long));
		*taskids[t] = t;
		rc = pthread_create(&threads[t], NULL, calculaX, (void *) taskids[t]);
		if(rc){
			printf("ERRO; codigo de retorno eh %d\n", rc);
			exit(-1);
		}
	}
	for(t = 0; t < N; t++) pthread_join(threads[t],NULL);
	pthread_barrier_destroy(&barrier);
	for(t = 0; t < N; t++) pthread_mutex_destroy(&mymutex[t]);
	pthread_exit(NULL);
	return 0;
}
