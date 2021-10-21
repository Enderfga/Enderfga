#include <queue>
#include <stack>
#include <unordered_set>
#include <unordered_map>
#include <string>
#include <iostream>
#include <cstdlib>
#include <ctime>
#include <time.h>
using namespace std;

struct borad {
    int status[9];//status[0]到status[8]表示3X3的矩阵，0表示空格
    int depth;//深度
    int Fn;//启发函数值，Fn = depth + hn即深度加曼哈顿距离
    borad* pre;//父指针，指向移动前的棋盘状态
    borad() : pre(0), status(), depth(0), Fn(INT_MAX - 1) {
        for (int j = 0; j < 9; j++) {
            status[j] = j;
        }
    }
    borad(borad* x, int i[9], int y, int z) : pre(x), depth(y), Fn(z) {
        for (int j = 0; j < 9; j++) {
            status[j] = i[j];
        }
    }
};

//优先队列自定义排序规则，升序
struct cmp {
    bool operator() (const borad* a, const borad* b) {
        return a->Fn > b->Fn;
    }
};

bool swapnum(int a, int b, int* status);//交换元素
int getindex(int* status, int num);//获得元素在棋盘上的一维坐标
void print(int* status);//打印棋盘
int hn(int* status, int* target);//当前状态与目标状态的曼哈顿距离
void printans(borad* cur);//打印解法，回溯
int status2int(int* status);//棋盘状态转为int格式
int reversesum(int* status);//计算逆序数之和
int* randstatus(int* target);//获得随机初始状态

int main() {
    clock_t start_t, end_t;
    double total_t;
    int go[4] = { -1,1,-3,3 };//四个移动方向
    int start[9] = { 1,8,7,3,0,5,4,6,2 };//初始状态
    int target[9] = { 1,2,3,4,5,6,7,8,0 };//目标状态
    //int* start;//随机初始状态
    //生成随机初始状态
    //start = randstatus(target);
    stack<borad*> D_open;//DFS的open表，使用栈，深度大的在表头
    queue<borad*> B_open;//BFS的open表，使用队列，深度小的在表头
    priority_queue<borad*, vector<borad*>, cmp> A_open;//A*的open表，使用优先队列，启发函数值小的元素在表头
    unordered_set<int> close;//close表，存放已访问过的状态，元素为状态的int格式
    //例：{ 1,2,3,8,0,4,7,6,5 }==》123804765(int)
    //{ 0,1,3,8,2,4,7,6,5 }==》13824765(int)


    A_open.push(new borad(NULL, start, 0, INT_MAX - 1));
    borad* temp = A_open.top();
    printf("初始状态：");
    print(temp->status);
    printf("目标状态：");
    print(target);

    start_t = clock();
    //--------------------------------------------start-A*-------- Fn=Gn+Hn -----------------------------//
    //初始状态压入队列
    printf("A* Fn=Gn+Hn：\n");
    while (!A_open.empty()) {
        //弹出一个状态
        borad* cur = A_open.top();
        A_open.pop();
        //hn=Fn-depth为与目标状态的曼哈顿距离，为0即到达目标状态
        if (cur->Fn - cur->depth == 0) {
            printf("到达目标状态\nclose表大小为%d\n目标状态深度为%d\n", close.size(), cur->depth);
            //printans(cur);
            break;
        }
        //存放int格式的状态
        int intstatus = status2int(cur->status);
        //出现重复状态
        if (close.count(intstatus)) {
            continue;
        }
        //加入close表，表示已访问过
        close.insert(intstatus);
        //获得0的坐标
        int zeroindex = getindex(cur->status, 0);
        for (int i = 0; i < 4; i++) {
            //新建节点，复制当前棋盘状态，深度+1
            borad* temp = new borad(cur, cur->status, cur->depth + 1, 0);
            //0向四个方向移动
            if (swapnum(zeroindex, zeroindex + go[i], temp->status)) {
                //移动成功
                //计算启发函数值，并更新节点
                temp->Fn = temp->depth + hn(temp->status, target);
                //加入A_open表
                A_open.push(temp);
            }
            else {
                //移动失败
                delete(temp);
            }
        }
    }
    //清空close表
    close.clear();
    //--------------------------------------------end-A*--------- Fn=Gn+Hn -------------------------//
    end_t = clock();
    //清空A_open
    while (!A_open.empty()) {
        A_open.pop();
    }
    total_t = (double)(end_t - start_t) / CLOCKS_PER_SEC;
    printf("总时间：%f\n\n\n", total_t);
    start_t = clock();
    //--------------------------------------------start-BFS------------------------------------------//
    //初始状态压入队列
    B_open.push(new borad(NULL, start, 0, INT_MAX - 1));
    printf("BFS：\n");
    while (!B_open.empty()) {
        //弹出一个状态
        borad* cur = B_open.front();
        B_open.pop();
        //与目标状态的距离，为0即到达目标状态
        if (hn(cur->status, target) == 0) {
            printf("到达目标状态\nclose表大小为%d\n目标状态深度为%d\n", close.size(), cur->depth);
            //printans(cur);
            break;
        }
        //存放int格式的状态
        int intstatus = status2int(cur->status);
        //出现重复状态
        if (close.count(intstatus)) {
            continue;
        }
        //加入close表，表示已访问过
        close.insert(intstatus);

        //获得0的坐标
        int zeroindex = getindex(cur->status, 0);
        for (int i = 0; i < 4; i++) {
            //新建节点，复制当前棋盘状态，深度+1
            borad* temp = new borad(cur, cur->status, cur->depth + 1, INT_MAX - 1);
            //0向四个方向移动
            if (swapnum(zeroindex, zeroindex + go[i], temp->status)) {
                //移动成功
                B_open.push(temp);
            }
            else {
                //移动失败
                delete(temp);
            }
        }
    }
    //清空close表
    close.clear();
    //--------------------------------------------end-BFS------------------------------------------//
    end_t = clock();
    total_t = (double)(end_t - start_t) / CLOCKS_PER_SEC;
    printf("总时间：%f\n\n\n", total_t);
    start_t = clock();
    //--------------------------------------------start-DFS------------------------------------------//
    //初始状态压入队列
    D_open.push(new borad(NULL, start, 0, INT_MAX - 1));
    printf("DFS：\n");
    while (!D_open.empty()) {
        //弹出一个状态
        borad* cur = D_open.top();
        D_open.pop();
        //if (cur->depth == 5) {
        //    break;
        //}
        //与目标状态的距离，为0即到达目标状态
        if (hn(cur->status, target) == 0) {
            printf("到达目标状态\nclose表大小为%d\n目标状态深度为%d\n", close.size(), cur->depth);
            //printans(cur);
            break;
        }
        //存放int格式的状态
        int intstatus = status2int(cur->status);
        //出现重复状态
        if (close.count(intstatus)) {
            continue;
        }
        //加入close表，表示已访问过
        close.insert(intstatus);

        //获得0的坐标
        int zeroindex = getindex(cur->status, 0);
        for (int i = 0; i < 4; i++) {
            //新建节点，复制当前棋盘状态，深度+1
            borad* temp = new borad(cur, cur->status, cur->depth + 1, INT_MAX - 1);
            //0向四个方向移动
            if (swapnum(zeroindex, zeroindex + go[i], temp->status)) {
                //移动成功
                D_open.push(temp);
            }
            else {
                //移动失败
                delete(temp);
            }
        }
    }
    //--------------------------------------------end-DFS------------------------------------------//
    end_t = clock();
    total_t = (double)(end_t - start_t) / CLOCKS_PER_SEC;
    printf("总时间：%f\n", total_t);
    //delete(start);
    return 1;
}

//打印棋盘
void print(int* status) {
    for (int i = 0; i < 9; i++) {
        if (i % 3 == 0) {
            printf("\n");
        }
        printf("%d ", status[i]);

    }
    printf("\n\n");
}

//获得元素在棋盘上的一维坐标
int getindex(int* status, int num) {
    for (int i = 0; i < 9; i++) {
        if (status[i] == num) {
            return i;
        }
    }
    return -1;
}

//交换元素
bool swapnum(int a, int b, int* status) {
    if (b >= 0 && b <= 8 && (a / 3 == b / 3 || a % 3 == b % 3)) {
        swap(status[a], status[b]);
        return true;
    }
    else {
        return false;
    }
}

//当前状态与目标状态的曼哈顿距离
int hn(int* status, int* target) {
    //获得当前状态与目标状态的二维x，y坐标
    int x, y, xt, yt, it, h = 0;
    for (int i = 0; i < 9; i++) {
        x = i % 3;
        y = i / 3;
        it = getindex(target, status[i]);
        xt = it % 3;
        yt = it / 3;
        h += abs(x - xt) + abs(y - yt);
    }
    return h;
}

//打印解法，回溯
void printans(borad* cur) {
    vector<string> ans;
    while (cur) {
        ans.push_back(to_string(cur->status[0]) + to_string(cur->status[1]) + to_string(cur->status[2]) + "\n"
            + to_string(cur->status[3]) + to_string(cur->status[4]) + to_string(cur->status[5]) + "\n"
            + to_string(cur->status[6]) + to_string(cur->status[7]) + to_string(cur->status[8]));
        cur = cur->pre;
    }
    for (int i = ans.size() - 1; i >= 0; i--) {
        printf("%s\n ↓\n", ans[i].c_str());
    }
    printf("END\n\n");
}

//棋盘状态转为int格式
int status2int(int* status) {
    int res = 0;
    for (int i = 0, j = 8; i < 9; i++, j--) {
        res += status[i] * pow(10, j);
    }
    return res;
}

//计算逆序数之和
int reversesum(int* status) {
    int sum = 0;
    for (int i = 0; i < 9; i++) {
        if (status[i] != 0) {
            for (int j = 0; j < i; j++) {
                if (status[j] > status[i]) {
                    sum++;
                }
            }
        }
    }
    return sum;
}

//获得随机初始状态
int* randstatus(int* target) {
    int* start = new int[9]();
    unordered_map<int, int> nums;//记录已添加的数
    srand((int)time(0));
    int element, sum1, sum2;
    sum2 = reversesum(target);
    //根据初始状态与目标状态的逆序数之和（sum1、sum2）是否相等，判断初始状态是否有解，不相等（即无解）则重新生成初始状态
    do {
        for (int i = 0; i < 9; i++) {
            element = rand() % 9;
            while (nums[element]) {
                element = rand() % 9;
            }
            nums[element]++;
            start[i] = element;
        }
        //清空记录
        nums.clear();
        //计算逆序数之和
        sum1 = reversesum(start);
    } while (sum1 % 2 != sum2 % 2);
    return start;
}