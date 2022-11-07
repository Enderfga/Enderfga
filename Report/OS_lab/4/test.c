/*
i.	用进程或线程实现前面的两个算法，算法A和B，其中：
	算法A：算法一到四任选一个；
	算法B:Dekker算法或者Peterson算法
观察算法多次运行，检测是否有同时进入临界区的情况，分析原因  
*/
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>
int turn = 1;
int flag[2] = {0, 0};
// 算法一：用turn序来轮流,严格轮转法
void *processA_1(void *arg)
{
    int i;
    for (i = 0; i < 7; i++)
    {
        while (turn != 0){printf("process1 is waiting\n");};
        printf("process1 is in critical section\n");
        turn = 1; // turn = 1, process2 can enter critical section
    }
}
void *processA_2(void *arg)
{
    int i;
    for (i = 0; i < 5; i++)
    {
        while (turn != 1){printf("process2 is waiting\n");};
        printf("process2 is in critical section\n");
        turn = 0; // turn = 0, process1 can enter critical section
    }
}
// 算法二：用flag[i]标志进程i进入临界区，双标志先检查法：
void *processB_1(void *arg)
{
    int i;
    for (i = 0; i < 5; i++)
    {
        while (flag[1] == 1){printf("process1 is waiting\n");};
        flag[0] = 1;
        printf("process1 is in critical section\n");
        flag[0] = 0;
    }
}
void *processB_2(void *arg)
{
    int i;
    for (i = 0; i < 5; i++)
    {
        while (flag[0] == 1){printf("process2 is waiting\n");};
        flag[1] = 1;
        printf("process2 is in critical section\n");
        flag[1] = 0;
    }
}
// 算法三：将flag[i]标志的设置提前到循环等待之前，双标志后检查法：
void *processC_1(void *arg)
{
    int i;
    for (i = 0; i < 5; i++)
    {
        flag[0] = 1;
        while (flag[1] == 1){printf("process1 is waiting\n");};
        printf("process1 is in critical section\n");
        flag[0] = 0;
    }
}
void *processC_2(void *arg)
{
    int i;
    for (i = 0; i < 5; i++)
    {
        flag[1] = 1;
        while (flag[0] == 1){printf("process2 is waiting\n");};
        printf("process2 is in critical section\n");
        flag[1] = 0;
    }
}
// 算法四：在循环等待中用延时给其他进程进入的机会
void *processD_1(void *arg)
{
    int i;
    for (i = 0; i < 5; i++)
    {
        flag[0] = 1;
        while (flag[1] == 1){flag[0] = 0;printf("process1 is waiting\n");sleep(1);flag[0] = 1;};
        printf("process1 is in critical section\n");
        flag[0] = 0;
    }
}
void *processD_2(void *arg)
{
    int i;
    for (i = 0; i < 5; i++)
    {
        flag[1] = 1;
        while (flag[0] == 1){flag[1] = 0;printf("process2 is waiting\n");sleep(1);flag[1] = 1;};
        printf("process2 is in critical section\n");
        flag[1] = 0;
    }
}
// 算法五：Dekker算法
void *processE_1(void *arg)
{
    int i;
    for (i = 0; i < 5; i++)
    {
        flag[0] = 1;
        while (flag[1] == 1)
        {
            if (turn == 1)
            {
                flag[0] = 0;
                while (turn == 1){printf("process1 is waiting\n");};
                flag[0] = 1;
            }
        }
        printf("process1 is in critical section\n");
        turn = 1;
        flag[0] = 0;
    }
}
void *processE_2(void *arg)
{
    int i;
    for (i = 0; i < 5; i++)
    {
        flag[1] = 1;
        while (flag[0] == 1)
        {
            if (turn == 0)
            {
                flag[1] = 0;
                while (turn == 0){printf("process2 is waiting\n");};
                flag[1] = 1;
            }
        }
        printf("process2 is in critical section\n");
        turn = 0;
        flag[1] = 0;
    }
}
// 算法六：Peterson算法
void *processF_1(void *arg)
{
    int i;
    for (i = 0; i < 5; i++)
    {
        flag[0] = 1;
        turn = 1;
        while (flag[1] == 1 && turn == 1){printf("process1 is waiting\n");};
        printf("process1 is in critical section\n");
        flag[0] = 0;
    }
}
void *processF_2(void *arg)
{
    int i;
    for (i = 0; i < 5; i++)
    {
        flag[1] = 1;
        turn = 0;
        while (flag[0] == 1 && turn == 0){printf("process2 is waiting\n");};
        printf("process2 is in critical section\n");
        flag[1] = 0;
    }
}
int main()
{
    pthread_t p1, p2;
    pthread_create(&p1, NULL, processF_1, NULL);
    pthread_create(&p2, NULL, processF_2, NULL);
    pthread_join(p1, NULL);
    pthread_join(p2, NULL);
    return 0;
}