#include <unistd.h> 
#include <pthread.h> 
#include <string.h> 
#include <iostream>
using namespace std;
pthread_mutex_t mutexA = PTHREAD_MUTEX_INITIALIZER; 
pthread_mutex_t mutexB = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t mutexC = PTHREAD_MUTEX_INITIALIZER; 

 
static int counterA = 0; 
static int counterB = 0; 

// 补充完成 func1 和 func2 中互斥锁的请求和释放操作 
int func1() 
{ 
    // 线程1先占有资源counterA，然后sleep，确保线程2占有counterB，然后再申请资源counterB
	int err;
	//pthread_mutex_lock(&mutexA); 
	err=pthread_mutex_trylock(&mutexA);
	if(err==EBUSY)
	{
		cout<<"线程1申请资源counterA失败"<<endl;
		return -1;
	}
	else
	{
		cout<<"线程1申请资源counterA成功"<<endl;
	}
	++counterA; 
	//sleep(1); 
    //cout<<"The thread1 "<<pthread_self()<<" is waiting for counterB"<<endl;

    //pthread_mutex_lock(&mutexB);
	err=pthread_mutex_trylock(&mutexB);
	if(err==EBUSY)
	{
		cout<<"线程1申请资源counterB失败"<<endl;
		return -1;
	}
	else
	{
		cout<<"线程1申请资源counterB成功"<<endl;
	}
	++counterB; 
    //cout<<"counterA="<<counterA<<",counterB="<<counterB<<endl;

	//死锁部分的代码以下需要切换顺序
    pthread_mutex_unlock(&mutexA);
    pthread_mutex_unlock(&mutexB);

	return counterA; 
} 

int func2() 
{ 
    // 线程2先占有资源counterB，然后sleep，确保线程1占有counterA，然后再申请资源counterA
	int err;
	//pthread_mutex_lock(&mutexB); 
	err=pthread_mutex_trylock(&mutexB);
	if(err==EBUSY)
	{
		cout<<"线程2申请资源counterB失败"<<endl;
		return -1;
	}
	else
	{
		cout<<"线程2申请资源counterB成功"<<endl;
	}
	++counterB; 
	//sleep(1); 
    //cout<< "The thread2 "<<pthread_self()<<" is waiting for counterA"<<endl;

    //pthread_mutex_lock(&mutexA);
	err=pthread_mutex_trylock(&mutexA);
	if(err==EBUSY)
	{
		cout<<"线程2申请资源counterA失败"<<endl;
		return -1;
	}
	else
	{
		cout<<"线程2申请资源counterA成功"<<endl;
	}
	++counterA; 
    //cout<<"counterA="<<counterA<<",counterB="<<counterB<<endl;
	
	//死锁部分的代码以下需要切换顺序
    pthread_mutex_unlock(&mutexA);
    pthread_mutex_unlock(&mutexB);

	return counterB; 
} 

void* start_routine1(void* arg) 
{ 
	while (1) 
	{ 
		int iRetValue = func1(); 

		if (iRetValue == 1) 
		{ 
			pthread_exit(NULL); 
		} 
	} 
} 

void* start_routine2(void* arg) 
{ 
	while (1) 
	{ 
		int iRetValue = func2(); 

		if (iRetValue == 1) 
		{ 
			pthread_exit(NULL); 
		} 
	} 
} 

void* start_routine(void* arg) 
{ 
	while (1) 
	{ 
		sleep(1); 
		char szBuf[128]; 
		memset(szBuf, 0, sizeof(szBuf)); 
		strcpy(szBuf, (char*)arg); 
	} 
}

int main() 
{ 
	pthread_t tid[4]; 
	if (pthread_create(&tid[0], NULL, &start_routine1, NULL) != 0) 
	{ 
		return -1; 
	} 
	if (pthread_create(&tid[1], NULL, &start_routine2, NULL) != 0) 
	{ 
		return -1; 
	}
    long long arg = 11111111;  
	if (pthread_create(&tid[2], NULL, &start_routine, &arg) != 0) 
	{ 
		return -1; 
	} 
	if (pthread_create(&tid[3], NULL, &start_routine, &arg) != 0) 
	{ 
		return -1; 
	} 

	sleep(5); 
	//pthread_cancel(tid[0]); 

	pthread_join(tid[0], NULL); 
	pthread_join(tid[1], NULL); 
	pthread_join(tid[2], NULL); 
	pthread_join(tid[3], NULL); 

	pthread_mutex_destroy(&mutexA); 
	pthread_mutex_destroy(&mutexB); 
	pthread_mutex_destroy(&mutexC); 


	return 0; 
}