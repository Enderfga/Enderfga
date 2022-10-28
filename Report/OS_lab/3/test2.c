#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
/* 
编写另一个C 程序，使用系统调用fork()以创建一个子进程，并使用这个子进程调用exec 函数族以执行系统命令ls。
 */
int main()
{
    pid_t pid;
    pid = fork();
    if (pid < 0)
    {
        printf("fork error\n");
    }
    else if (pid == 0)
    {
        printf("child process\n");
        execl("/bin/ls", "ls", NULL);
    }
    else
    {
        printf("parent process\n");
        wait(NULL);
    }
    return 0;
}