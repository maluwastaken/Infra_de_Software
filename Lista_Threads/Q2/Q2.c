#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int flag=0;
pthread_mutex_t mymutex = PTHREAD_MUTEX_INITIALIZER;
pthread_barrier_t barrier;

long n, t;					// N numero de usuarios, A numero de arquivos(A >= 2) e T numero de threads(T<=floor(A/2))
int a;
float soma=0;
int contador=0;

typedef struct Usuario{		//uma estrutura que recebe o usuario do arquivo
	char nome[100];
	char id[100];
	char ultimoAcessoC[100];
	char pontuacaoC[100];
	int ultimoAcesso;
	float pontuacao;
	float grauInatividade;
	int numUser;

}Usuario;						
	Usuario **meuUser;				//cria uma matriz da estrutura
void *entraArquivo(void *threadId){	//essa funcao serve para entrar em cada arquivo de forma inteligente
	int tid = *((int *)threadId);	//recebe o id da thread
	int tidInicial =tid;			
	int i=0;	
	char nomeArq[100];
	char b[100];

while(tid<=a){						//faz enquanto ta dentro do numero de arquivos que sao possives de serem acessados

	sprintf(b, "banco%d.txt", tid); //isso aqui serve para concatenar strings com inteiros
	strcpy(nomeArq,b);				//acessa arquivo baseado no seu id
									//coloca o nome do arquivo banco + inteiro atual +  .txt

	FILE *meuArquivo;
	meuArquivo = fopen(nomeArq,"r");//abre o arquivo na forma de leitura
	i=0;
	while(fscanf(meuArquivo, "%s %s %s %s", meuUser[tid][i].nome, meuUser[tid][i].id, meuUser[tid][i].ultimoAcessoC,meuUser[tid][i].pontuacaoC) != EOF){//pega todo os  usuarios do arquivo
	meuUser[tid][i].pontuacao=atof(meuUser[tid][i].pontuacaoC);		//transformar string em float
	meuUser[tid][i].ultimoAcesso=atoi(meuUser[tid][i].ultimoAcessoC);//transforma string em float

	pthread_mutex_lock(&mymutex);
	soma+= ((float)meuUser[tid][i].ultimoAcesso/(meuUser[tid][i].pontuacao*meuUser[tid][i].pontuacao))/n; 							//faz o somatorio entre todos os arquivos 
	meuUser[tid][i].grauInatividade=((float)meuUser[tid][i].ultimoAcesso/(meuUser[tid][i].pontuacao*meuUser[tid][i].pontuacao))/n;	//salva o graud e inatividade de tal usuario
	pthread_mutex_unlock(&mymutex);//desloca
	i++;
	}
meuUser[tid][0].numUser =i;
	

fclose(meuArquivo);
tid+=t;//eu somo o numero de threads a ele por exemplo, tengo 8 arquivos e 2 threads, thread 1 faz arquivo 0, dps arquivo 2 e dps arquivo 4, enquanto thread 2 faz 1, 3,5...

}

pthread_barrier_wait(&barrier); //espera todas as somas acontecerem para seguir adiante

//soma=soma/n;
tid =tidInicial;				//volta pro arquivo inicial
int j;
while(tid<=a){

	sprintf(b, "banco%d.txt", tid); //ACESSA OS ARQUIVOS NOVAMENTE PARA ESCREVER AGORA
	strcpy(nomeArq,b);
	FILE *meuArquivo;
	meuArquivo = fopen(nomeArq,"w");
	
	
	for(j=0;j<meuUser[tid][0].numUser;j++){//escreve no arquivo caso seja menos q 2*media 
		if(2*soma>=(float)meuUser[tid][j].ultimoAcesso/(meuUser[tid][j].pontuacao*meuUser[tid][j].pontuacao)){
			fprintf(meuArquivo,"%s %s %s %s\n",meuUser[tid][j].nome, meuUser[tid][j].id, meuUser[tid][j].ultimoAcessoC, meuUser[tid][j].pontuacaoC);
			printf("%s %s %s %s\n",meuUser[tid][j].nome, meuUser[tid][j].id, meuUser[tid][j].ultimoAcessoC, meuUser[tid][j].pontuacaoC);
		}
	}
	fclose(meuArquivo);
	tid+=t;//vai acessar proximo arquivo possivel
}

	pthread_exit((void*) 0);
}
int main (int argc, char *argv[]){
	scanf("%ld %d %ld", &n,&a,&t); // N numero de usuarios, A numero de arquivos(A >= 2) e T numero de threads(T<=floor(A/2))
	pthread_barrier_init(&barrier, NULL, t);
	meuUser= (Usuario **) malloc(n*sizeof(Usuario*));//declara o tamanho da estrutura;//VOU MUDAR ISSO AQUI PRA UM ARRAY EM VEZ DE UM VETOR
	int j;
	for(j=0;j<n;j++)
	meuUser[j]=(Usuario *)malloc(n*sizeof(Usuario));
	
	pthread_t *threads=(pthread_t *)malloc(t*sizeof(pthread_t)); //declara o numero de threads(mudei pra malloc pq eu achei q tava invadindo memoria, mas foi besteira minha)
	long *taskids[t];
	void *status;
	int rc, i;
	for(i=0; i<t; i++){
		taskids[i] = (long *) malloc(sizeof(long));//cria uma parada pra guardar o ID
		*taskids[i] = i+1;//da o ID pra essa parada
		rc = pthread_create(&threads[i], NULL, entraArquivo, (void *) taskids[i]);  //numero da thread, atributo?, funcao, argumento
		if (rc){
			printf("ERRO; cÃ³digo de retorno Ã© %d\n", rc);
			exit(-1);
			}
		}

	for(i=0; i<t; i++)
    pthread_join(threads[i], &status);//espera todas sairem

    pthread_mutex_destroy(&mymutex);
    pthread_exit(NULL);


}
