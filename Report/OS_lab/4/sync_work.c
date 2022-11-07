#include <semaphore.h>
#include <stdio.h>   
#include <stdlib.h>     
#include <string.h>
#include <pthread.h> 
#define MAX 256
char *buffer;
sem_t empty;    //定义同步信号量empty
sem_t full;	//定义同步信号量full
sem_t mutex;	//定义互斥信号量mutex

void * producer(void* args)	//生产者
{
  sem_wait(&empty);	//empty的P操作
  sem_wait(&mutex);	//mutex的P操作
  printf("input something to buffer:");
  buffer=(char *)malloc(MAX);	//给缓冲区分配内存空间
  fgets(buffer,MAX,stdin);	//输入产品至缓冲区
  sem_post(&mutex);	//mutex的V操作
  sem_post(&full);	//full的V操作
}
void * consumer(void * args)	//消费者
{
  sem_wait(&full);	//full的P操作
  sem_wait(&mutex);	//mutex的P操作
  printf("read product from buffer:%s",buffer); //从缓冲区中取出产品
  memset(buffer,0,MAX);		//清空缓冲区
  sem_post(&mutex);	//mutex的V操作
  sem_post(&empty);	//empty的V操作
}
int main()
{
  pthread_t id_producer;
  pthread_t id_consumer;
  int ret;
  

  sem_init(&empty,0,10);	//设置empty到初值为10
  sem_init(&full,0,0);		//设置full到初值为0
  sem_init(&mutex,0,1);		//设置mutex到初值为1
  //创建生产者线程
  ret=pthread_create(&id_producer,NULL,producer,NULL);
  //创建消费者线程
  ret=pthread_create(&id_consumer,NULL,consumer,NULL);
  pthread_join(id_producer,NULL);	//等待生产者线程结束
  pthread_join(id_consumer,NULL);//等待消费者线程结束
  sem_destroy(&empty);		//删除信号量
  sem_destroy(&full);
  sem_destroy(&mutex);
  printf("The End...\n");
}
