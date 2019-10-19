 #include <bits/stdc++.h>
#define N 2
#define bufferTam 100 //INDICA TAMANHO DO BUFFER
#define numReq 200 //OMDOCA NUMERO DE REQUISICOES

using namespace std;
int numThreads=0;
pthread_mutex_t mutexs = PTHREAD_MUTEX_INITIALIZER;			//mutex de uso real
pthread_mutex_t mutexThread= PTHREAD_MUTEX_INITIALIZER;		//Mutex para a criacao de threads
pthread_cond_t Threads=PTHREAD_COND_INITIALIZER;			//condicional para produtor consumidor para criacao de threads
pthread_cond_t empty = PTHREAD_COND_INITIALIZER;			//condicional para produtor consumidor de requisicoes do buffer vazio
pthread_cond_t fillo = PTHREAD_COND_INITIALIZER;			//condicional para produtor consumidor de requisicoes do buffer cheio
pthread_mutex_t BufferMutex[numReq];//={PTHREAD_MUTEX_INITIALIZER}; //serve para a funcao pegarResultado saber se ja pode ou nao acessar o buffer de respostas
pthread_cond_t BufferCond[numReq];//={PTHREAD_MUTEX_INITIALIZER};	//serve como condicao para pegar resultado

pthread_mutex_t mutexPrint = PTHREAD_MUTEX_INITIALIZER; //um mutex que serve apenas para os prints naos e sobreporem

long long ID = 0;	//o id que damos pra cada execucao de funcao
int contador=0;  	//um contador para  dar os argumentos das funcoes sem se atrapalharem
int threadDisponivel[N]={1};	//determina as threads estao disponiveis para serem criadas(inicialmente todas)

class bufferResp{ 					//a classe funciona como uma estrutura. e serve para criar um Buffer de Saida;
	public:
		int retorno;     			//o valor de retorno da funcao
		int disponivel;				//diz se a funcao esta disponivel para ser acessado pela funcao pegar resultado
		
		bufferResp(){
			this->disponivel=0;		//inicializa a disponibildiade com 0
		}
};

bufferResp bufferResposta[numReq]; //Cria um buffer de saida

class func{						//cria uma estrutura que recebe uma fucnao e um argumento, (o valor A eh o valor numerico do argumento e o arg e um ponteiro para ele)
    public:
    void* (*funcao)(void*);  	//ponteiro do tipo void *
    void *arg;
    int a;
    int id;
};

queue<func> buffer; 		 //cria uma fila que servirar como buffer de entrada

void ehpar(void *num){ 			//uma funcao que poderia servir como funexec
    long a = *((long*)num);		

    if(a%2 == 0)
        cout << "eh par" << endl;
    else cout << "nao eh par" << endl;
}

void *printa(void *num){			//outra funcao que poderia servir como funexec
    int c = *((int *)num);
    pthread_mutex_lock(&mutexPrint);
    cout <<"Printa: " <<c<< endl;
    pthread_mutex_unlock(&mutexPrint);
    
}
int geraID(int id){				//funcao generica para gerar IDS, no caso da nossa, eh uma geracao sequencial de IDS
	return (id+1);
}
int agendarExecucao(void *estrutura){ //Funcao que gera ids para colocar no buffer (funciona como um produtor)
 
    
    func tudo=*((func*) estrutura);	  //recebe uma estrutura q contem a funcao e o argumento da funcao
    tudo.id=ID;						  //da um id para essa estrutura;
    pthread_mutex_lock(&mutexs);		  
    while(buffer.size()==bufferTam){ pthread_cond_wait(&empty, &mutexs); } //essa eh a parte do produtor, se buffer tiver cheio dorme.
    
    buffer.push(tudo);									   //se nao tiver cheio, coloca a estrutura no buffer
    if(buffer.size()==1)  pthread_cond_broadcast(&fillo); //se tiver pelo menos 1 elemento no buffer, acorta todos os consumidores
    pthread_mutex_unlock(&mutexs); 

ID=geraID(ID);						//FUNCAO PRA GERAR ID, NO CASO DESSE PROGRAMA CRIAMOS O ID SEQUENCIAL
    //return ID;
}

void *ExecutaThread(void *arg){  //funcao que vai receber a estrutura do buffer e vai executar a funcao e salvar o retorno no buffer de resultado
    func b = *((func *)arg);  

	      
	   pthread_mutex_lock(&BufferMutex[b.id]); //serve para travar o acesso a determinada posicao do buffer de resultado
   
   b.funcao(&b.a);    							//executa a funcao com seu argumento
   pthread_mutex_lock(&mutexThread);  			//trava mutex de criacao de threads 
   numThreads--;								//diminui o numero de threads sendo usados no momento
   if(numThreads== N-1){ pthread_cond_signal(&Threads); }	//destrava o criador de threads;(serve como consumidor de threads)
    pthread_mutex_unlock(&mutexThread);						//destrava o multex de criacao de threads
	bufferResposta[b.id].retorno=b.a;						//enche o buffer de resposta com a respectiva resposta
   	bufferResposta[b.id].disponivel=1;						//diz q a resposta esta disponivel
   	 pthread_cond_signal(&BufferCond[b.id]);				//Acorda a funcao de pegarResultado caso ela tenha tentando pegar um resultado que ainda nao esta pronto
   	 
    

	pthread_mutex_unlock(&BufferMutex[b.id]);

 }

void despachante(void *argument){  	   	         //essa funcao serve como consumidor do buffer e como produtor de threads
    pthread_t *threads;
    threads = new pthread_t[N];
    int i=0;		
    func *argumento=(func *) malloc(numReq*sizeof(func));
     pthread_mutex_lock(&mutexs);
	
	 while(buffer.size() == 0){   						//consumidor do buffer de requisicoes
         pthread_cond_wait(&fillo, &mutexs); 			//dorme caso buffer esteja vazio
         }
         	pthread_mutex_lock(&mutexThread);		
            while(numThreads==N){ 						//Produtor de threads
                pthread_cond_wait(&Threads, &mutexThread); //dorme caso nao possa criar threads
                }   
                do{
                    if(threadDisponivel[i]==1){				//procura qual thread ta disponivel para ser criada
                        argumento[contador]=buffer.front();	//pega o primeiro item da lista buffer de requisicoes
                        buffer.pop();						//diminui o size do buffer em um;
                        pthread_create(&threads[i], NULL, ExecutaThread,&argumento[contador]);//croi a thread que executa a funcao recebida
                       	threadDisponivel[i]==0; 			//diz q tal thread nao esta mais disponivel para ser criada
                       	numThreads++;						//aumenta o numero de threads
                       	contador++;							//passa para proximo argumento (para nao embaralhar os argumentos)
                       	pthread_mutex_unlock(&mutexThread); 
                    }
                        

                i++;
                }while(threadDisponivel[i-1]==0);   //serve para procurar uma thread q nao esta sendo utilziada no momento 

   if(buffer.size() == bufferTam-1){ pthread_cond_signal(&empty); } //caso tenha espaco para produtor colocar no buffer, acorda o produtor
    pthread_mutex_unlock(&mutexs);
   
}

void *despachador(void *argument){ 					//serve apenas para determinar quantas requisicoes o despachador vai tirar do buffer
    for(int i=0;i<numReq;i++)
    despachante(NULL);
   

}
int pegarResultadoExecucao(int id){						//essa funcao serve para pegar as requisicoes do buffer de resultados(de saida) e ver os valores de retorno
	pthread_mutex_lock(&BufferMutex[id]);				//ve se esta disponivel para ser acessado
	while(bufferResposta[id].disponivel==0){			//se nao estiver diponivel, dorme
		pthread_cond_wait(&BufferCond[id], &BufferMutex[id]);
		}
		pthread_mutex_lock(&mutexPrint);
		cout << "Recebi:"<< bufferResposta[id].retorno<<", da execucao do id: "<<id<<endl; //mostra o valor que recebeu
		bufferResposta[id].disponivel==0;													//abre espaco no buffer de saida
		pthread_mutex_unlock(&mutexPrint);
		pthread_mutex_unlock(&BufferMutex[id]);
	
}

int main(){

    pthread_t *threads;
    threads = new pthread_t[N];
    long *taskids = new long[N];
    func *minhaFuncao=(func *)malloc(numReq*sizeof(func));
    for(int i=0;i<numReq;i++){
    BufferMutex[i]=PTHREAD_MUTEX_INITIALIZER; //serve para a funcao pegarResultado saber se ja pode ou nao acessar o buffer de respostas
    BufferCond[i]=PTHREAD_COND_INITIALIZER;
    }
   
     int rc;
      pthread_create(&threads[0], NULL, despachador, NULL);//cria um despachador que vai rodar simultaneamente no codigo

   for(int t=0;t<numReq;t++){
   		minhaFuncao[t].funcao = printa;			//recebe a funcao generica(funexec)
		minhaFuncao[t].a=t*432/3; 				//cria um argumento pseudo aleatorio(mas dependendo da aplicacao esse valor pode ser mudado, mas por simplicidade dcolocamos desse jeito)
   		minhaFuncao[t].arg=&minhaFuncao[t].a;	//pega um pontei
       agendarExecucao(&minhaFuncao[t]);		//chama afuncao apr acolocar as requisicoes no buffer
	}
  
    for(int t =0; t <numReq; t++){
    	pegarResultadoExecucao(rand()%numReq);	//serve para um acesso aleatorio de Ids(pode ser sequencial tambem, mas resolvemos fazer dess ejeito. Depende da aplicacao);
    	//pegarResultadoExecucao(t);
	} 
   
   pthread_join(threads[0],NULL); 

    return 0;
}
