#include <bits/stdc++.h>
#define id first
#define valor second

using namespace std;

vector<vector<pair<int,double> > > M, M2;
vector<vector<double> > M3, MRm;
vector<double> V, MRv; 
int ln, cl;
pthread_t *threads;

void* MatrizVetor(void *threadid){//matriz esparsa x vetor denso
	long *tid = (long *)threadid;
	for(int i = 0; i < M[(*tid)].size(); i++){
		int mid = M[(*tid)][i].id;
		MRv[(*tid)] += M[(*tid)][i].valor * V[mid];
	}
}

void* doubleMatrizEsp(void *threadid){//matriz esparsa x matriz esparsa
	//percorre a matriz esparsa 1, multiplicando seus elementos com os elementos da matriz densa que estao na coluna (de M2) correspondente de sua coluna (em M)
	//o resultado é colocado na matriz resultado na mesma linha do elemento na matriz esparsa e na coluna do elemento da matriz esparsa 2
	long *tid = (long *)threadid;
	for(int i = 0; i < M[(*tid)].size(); i++){
		int mid = M[(*tid)][i].id;
		for(int k = 0; k < M2[mid].size(); k++){
			MRm[(*tid)][M2[mid][k].id] += M[(*tid)][i].valor * M2[mid][k].valor;	
		}
	}	
}

void* MatEspxDen(void *threadid){//matriz esparsa x matriz densa
	long *tid = (long *)threadid;
	//percorre a matriz esparsa, multiplicando seus elementos com os elementos da matriz densa que estao na linha (de M3) correspondente de sua coluna (em M)
	//o resultado é colocado na matriz resultado na mesma linha do elemento na matriz esparsa e na coluna do elemento da matriz densa (M3)
	for(int i = 0; i < M[(*tid)].size(); i++){
		for(int k = 0; k < cl; k++){
			int mid = M[(*tid)][i].id;
			MRm[(*tid)][k] += M[(*tid)][i].valor * M3[mid][k];	
		}	
	}
}

int main(){
	cout << "digite o numero da operacao que deseja:\n";
	cout << "1 - Multiplicar matriz esparsa por vetor denso\n";
	cout << "2 - Multiplicar matriz esparsa por matriz esparsa\n";
	cout << "3 - Multiplicar matriz esparsa por matriz densa\n";
	int escolha; cin >> escolha;
	
	if(escolha == 1){//matEsparsa x vetDenso
		//Coleta das entradas
		int n;
		cout << "Insira o numero de linhas do vetor\n";
		cin >> n; cl = n;
		V.resize(n);
		cout << "Agora suas entradas\n";
		for(int i = 0; i < n; i++) cin >> V[i];
		
		cout << "Insira o numero de linhas da matriz, que tera " << cl << " colunas\n";
		cin >> n; ln = n;
		MRv.resize(ln);
		M.resize(n);
		for(int i = 0; i < n; i++){
			cout << "Insira o numero de entradas para a linha " << i << "\n";
			int k; cin >> k;
			cout << "Agora suas entradas\n";
			for(int j = 0; j < k; j++){
				int a; double b;
				cin >> a >> b;
				M[i].push_back({a, b});
			}
		}
		//criacao das threads e seus ids
		threads = new pthread_t[n];
		long *taskids = new long[ln];
		
		for(int t = 0; t < ln; t++){
			taskids[t] = t;
			pthread_create(&threads[t], NULL, MatrizVetor, &taskids[t]);
		}
		for(int t = 0; t < ln; t++) pthread_join(threads[t],NULL); 
		
		cout << "Resultado:\n";
		for(int i = 0; i < MRv.size(); i++) cout << MRv[i] << " ";	
	}
	
	else if(escolha == 2){//matEsparsa x matEsparsa
		//Coleta das entradas
		int n, m;
		cout << "Insira o numero de linhas e colunas da matriz esparsa 1\n";
		cin >> m >> n; ln = m;
		M.resize(m);
		for(int i = 0; i < m; i++){
			cout << "Insira o numero de entradas para a linha " << i << "\n";
			int k; cin >> k;
			for(int j = 0; j < k; j++){
				int a; double b;
				cin >> a >> b;
				M[i].push_back({a, b});
			}
		}
		
		cout << "Insira o numero de colunas da matriz esparsa 2, que tera " << n << " linhas\n";
		cin >> m; cl = m;
		MRm.resize(ln);
		M2.resize(n);
		for(int i = 0; i < n; i++){
			cout << "Insira o numero de entradas para a linha " << i << "\n";
			int k; cin >> k;
			for(int j = 0; j < k; j++){
				int a; double b;
				cin >> a >> b;
				M2[i].push_back({a, b});
			}
		}
		//ajuste do tamanho da matriz resultado de acordo com os numeros de linhas e colunas fornecidos
		for(int i = 0; i < ln; i++)
			for(int j = 0; j < cl; j++)
				MRm[i].push_back(0);
		
		//criacao das threads e seus ids
		threads = new pthread_t[ln];
		long *taskids = new long[ln];
		
		for(int t = 0; t < ln; t++){
			taskids[t] = t;
			pthread_create(&threads[t], NULL, doubleMatrizEsp, &taskids[t]);
		}
		for(int t = 0; t < ln; t++) pthread_join(threads[t],NULL); 
		
		cout << "Resultado:\n";
		for(int i = 0; i < MRm.size(); i++){
			for(int j = 0; j < MRm[i].size(); j++)
				cout << MRm[i][j] << " ";
			cout << "\n";
		} 
	}
	
	else{//matEsparsa x matDensa
		//Coleta das entradas
		int n, m;
		cout << "Insira o numero de linhas e colunas da matriz densa\n";
		cin >> m >> n; cl = n;
		M3.resize(m);
		for(int i = 0; i < m; i++){
			M3[i].resize(n);
		}
		double aux;
		cout << "Agora suas entradas\n";
		for(int i = 0; i < m; i++)
			for(int j = 0; j < n; j++)
				cin >> M3[i][j];
		
		cout << "Insira o numero de linhas da matriz, que tera " << n << " colunas\n";
		cin >> m; ln = m;
		MRm.resize(ln);
		M.resize(m);
		for(int i = 0; i < m; i++){
			cout << "Insira o numero de entradas para a linha " << i << "\n";
			int k; cin >> k;
			cout << "Agora suas entradas\n";
			for(int j = 0; j < k; j++){
				int a; double b;
				cin >> a >> b;
				M[i].push_back({a, b});
			}
		}
		//ajuste do tamanho da matriz resultado de acordo com os numeros de linhas e colunas fornecidos
		for(int i = 0; i < ln; i++)
			for(int j = 0; j < cl; j++)
				MRm[i].push_back(0);
		
		//criacao das threads e seus ids
		threads = new pthread_t[n];
		long *taskids = new long[ln];
		
		for(int t = 0; t < ln; t++){
			taskids[t] = t;
			pthread_create(&threads[t], NULL, MatEspxDen, &taskids[t]);
		}
		for(int t = 0; t < ln; t++) pthread_join(threads[t],NULL); 
		
		cout << "Resultado:\n";
		for(int i = 0; i < MRm.size(); i++){
			for(int j = 0; j < MRm[i].size(); j++)
				cout << MRm[i][j] << " ";
			cout << "\n";
		} 
	}
		
	pthread_exit(NULL);
	return 0;
}
