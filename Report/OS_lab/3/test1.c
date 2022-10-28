#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
/* ①在子进程中分别输出当前进程为子进程的提示、当前进程的PID 和父进程的PID、根据用户输入确定当前进程的返回值、退出提示等信息。
②在父进程中分别输出当前进程为父进程的提示、当前进程的PID 和子进程的PID、等待子进程退出后获得的返回值、退出提示等信息。
 */
int main() {
    pid_t pid;
    pid = fork();
    if (pid < 0) {
        printf("fork error!\n");
        return -1;
    } else if (pid == 0) {
        printf("I am child process, my pid is %d, my parent pid is %d\n", getpid(), getppid());
        int ret;
        printf("Please input a number: ");
        scanf("%d", &ret);
        printf("I am child process, I will exit with %d\n", ret);
        return ret;
    } else {
        printf("I am parent process, my pid is %d, my child pid is %d\n", getpid(), pid);
        int status;
        wait(&status);
        printf("I am parent process, my child process exit with %d\n", WEXITSTATUS(status));
        return 0;
    }
}
