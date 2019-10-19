#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <stdbool.h>   

pthread_mutex_t mymutexAtual = PTHREAD_MUTEX_INITIALIZER, mymutexFlag = PTHREAD_MUTEX_INITIALIZER;
long first, second, atual = 0, contPrim=0; 
int flag=0;

void *primos(void *threadid){ //quantos primos existem dentro do intervalo
    bool composto = false;
    int j; 
	long *tid = (long *)threadid; 
    if((*tid) != 1 ){//o numero um não é primo
        for(j = 2; j < (*tid) && !composto; j++)//verifica se o numero é divisivel por todos os numeros menores que ele
            if((*tid) % j == 0) composto = true; // se for, ele eh composto --> sai do laco
        if(!composto) contPrim++;
    }
	pthread_exit(NULL);
}

long max = 0;
void *divisores(void *threadid){//maior quantia de divisores dentro do intervalo
	long *tid = (long *)threadid, contDiv = 0;
	int j;
	if((*tid )!= 1){
		for(j = 1; j <= (*tid); j++)
			if((*tid) % j == 0) contDiv++;
		if(contDiv > max) max = contDiv;
	}
	pthread_exit(NULL);
}

long comMaisDivs = 0, max2 = 0;
void *maisDivs(void *threadid){//encontra o numero do intervalo com mais divisores
	long *tid = (long *)threadid, contDiv = 0;
	int j;
	if((*tid) != 1){
		for(j = 1; j <= (*tid); j++)
			if((*tid) % j == 0) contDiv++;
		if(contDiv > max2) {
			max2 = contDiv;
			comMaisDivs = (*tid);
		}
	}
	pthread_exit(NULL);
}


void *interval(void *arg){//percorre o intervalo dado
	pthread_t threadPrim, threadDiv, threadMaisDiv;
  	bool done = true;
    int i, j;
    for(i = first; i <= second; i++){//criar as threads que farao as operacoes
        long *id = malloc(sizeof(long));
        *id = i;
	    pthread_create(&threadPrim, NULL, primos, (void*)id); 
        pthread_create(&threadDiv, NULL, divisores, (void*)id); 
	    pthread_create(&threadMaisDiv, NULL, maisDivs, (void*)id); 
        pthread_join(threadPrim, NULL);
	    pthread_join(threadDiv, NULL); 
	    pthread_join(threadMaisDiv, NULL); 
        
    }
    printf("%ld %ld %ld", contPrim, max, comMaisDivs);
    pthread_exit(NULL);
}

int main (int argc, char *argv[]){ 
	scanf("%ld %ld", &first, &second);
	pthread_t threadinterval;   
    pthread_create(&threadinterval, NULL, interval, NULL);
    pthread_mutex_destroy(&mymutexFlag);
    pthread_exit(NULL);   
	return 0;
}
