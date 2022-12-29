/*
 Gama
*/
#include <iostream>
#include <string>
#include <fstream>
#include<cstdio>
#include <cstring>
#define MaxUsers 5
using namespace std;
//磁盘结构体
typedef struct diskList
{
    int maxlength;//磁块的大小
    int start;//磁块的起始地址
    int useFlag;//标志该磁块是否已使用过
    char* text;//存放的文件内容
    diskList* next;
}diskNode;
//文件结构体
struct fileList
{
    string filename;//文件名
    int start;//物理地址
    int length;//文件长度
    int maxlength;//文件的最大长度
    char fileKind;//文件类型：只读0 只写1 读写2
    char protect;//保护码
    bool openflag;//打开标志，当为true时标志该文件正打开
};
typedef struct UserFileDirectory
{
    fileList* file;//连接文件
    UserFileDirectory* next;//连接用户目录项
}UFD;
typedef struct MasterFileDirectory
{
    string username;
    string password;
    UFD* user;//连接用户目录项
}MFD;
class ClassDesign
{
private:
    diskNode* diskHead;//磁块头
    MFD user[MaxUsers];//主文件目录
    int MaxUser;//最多用户量
    int NowUser;//当前用户
    int Used;//已有用户数
    string Now_Filename;//当前正在操作的文件名
    bool FileOpen = false;
public:
    void Initdata();//初始化数据
    void userCreate();//创建用户
    int login();//用户登录
    int requestDisk(int& startindex, int length);//为文件分配存储磁块
    void fileCreate();//创建文件
    void freeDisk(int startPostion);//释放磁块
    void fileDelete();//删除文件
    void fileRead();//文件读操作
    void filewrite();//文件写操作
    void fileDir();//列出目录项信息
    void fileclose();//关闭文件
    void fileopen();//打开文件
    void FreeSpace();//释放各个链表所占空间
    void SaveData();//保存用户信息与目录信息
    string getNowuser();//获取当前用户名
};
string ClassDesign::getNowuser()
{
    string a = user[NowUser].username;
    if(a=="")
        return "";
    else
        return a;
}

void ClassDesign::Initdata()
{
    MaxUser = 5;
    Used = 0;
    NowUser=-1;
    Now_Filename = "";
    diskHead = new diskNode;
    diskHead->start = 0;
    diskHead->useFlag = 0;
    diskHead->maxlength = 1000;
    diskHead->next = NULL;
}
void ClassDesign::userCreate()
{
    string username;
    string password;
    if (Used < MaxUser)
    {
        cout << "请输入要创建的用户名：";
        cin >> username;
        
        for (int i = 0; i < Used; i++)
        {
            while (user[i].username == username)
            {
                cout << "该用户名已存在，请重新输入:";
                cin >> username;
            }
        }
        user[Used].username = username;
        cout << "请输入密码:";
        cin >> password;
        user[Used].password = password;
        cout << "创建用户成功！" << endl;
        user[Used].user = new UFD;//初始化用户文件目录头
        user[Used].user->file = NULL;
        user[Used].user->next = NULL;
        Used++;
    }
    else
    {
        cout << "创建用户失败，用户数额已满。" << endl;
    }
    fflush(stdin);//清除文件缓冲区
    return;
}
int ClassDesign::login()
{
    if (Used == 0)
    {
        cout << "当前无用户，请先注册" << endl;
        return 0;
    }
    string name, psw;
    bool flag = false;//标志是否找到用户名
    int i;
    cout << "请输入要登录的用户名:";
    cin >> name;
    for (i = 0; i < Used; i++)
    {
        if (user[i].username == name)
        {
            flag = true;
            break;
        }
    }
    if (flag == true)
    {
        cout << "请输入密码:";
        cin >> psw;
        if (user[i].password == psw)
        {
            cout << "登录成功！" << endl;
        }
        else
        {
            cout << "密码错误，您还有一次机会，请重试:";
            cin >> psw;
            if (user[i].password == psw)
            {
                cout << "登录成功！" << endl;
            }
            else
            {
                cout << "密码错误，退出。" << endl;
                return 0;
            }
        }
    }
    else
    {
        cout << "用户名错误" << endl;
        login();//重新输入
    }
    fflush(stdin);
    NowUser = i;
    return i;//返回当前用户在MFD数组的下标
}
int ClassDesign::requestDisk(int& startindex, int length)
{
    //请求分配磁块
    int sucess = 0;//标志分配是否成功
    diskNode* p, * q, * temp;
    p = diskHead;
    while (p)
    {
        if (p->useFlag == 0 && p->maxlength >= length)
        {
            //将当前磁块分配出去
            p->useFlag = 1;
            startindex = p->start;//记下存放文件的起始物理地址
            
            // TODO 1  补充磁盘申请程序 
            p->text = new char[length];
            q = new diskNode;
            q->start = p->start + length;
            q->maxlength = 1000;
            q->useFlag = 0;
            q->next = NULL;

            //将新建磁块插入磁块链表表尾，保证链表中总有空闲磁块
            temp = p;
            //将新磁块指针p插入磁块链表
            if (diskHead->next == NULL)
                diskHead->next = q;
            else
            {
                while (temp->next)
                    temp = temp->next;
                temp->next = q;
            }
            sucess = 1;//标志分配磁块成功
            break;
        }
        p = p->next;
    }
    return sucess;
}
void ClassDesign::fileCreate()
{
    string filename;
    int length;
    char fileKind;
    cout << "请输入想要创建的文件名:";
    cin >> filename;
    cout << "请输入文件的长度:";
    cin >> length;
    cout << "请输入文件的类型:(0只读1只写2读写)";
    cin >> fileKind;
    
    UFD* fileNode, * p;
    int start;
    //遍历二级目录，判断文件是否重名
    if(NowUser==-1)
    {
        cout<<"当前未登陆"<<endl;
        return ;
    }
    if (user[NowUser].user->next)
    {
        for (p = user[NowUser].user->next; p != NULL; p = p->next)
        {
            if (p->file->filename == filename)
            {
                cout << "文件重名，创建失败。" << endl;
                return;
            }
        }
    }
    //文件不重名，申请磁块
    if (requestDisk(start, length))
    {
        fileNode = new UFD;
        fileNode->file = new fileList;
        fileNode->file->filename = filename;
        fileNode->file->fileKind = fileKind;
        fileNode->file->length = length;
        fileNode->file->start = start;
        fileNode->file->openflag = false;
        fileNode->file->protect = fileKind;
        fileNode->next = NULL;
        if (user[NowUser].user == NULL)
        {
            user[NowUser].user = fileNode;
        }
        else
        {
            p = user[NowUser].user;
            while (p->next)
                p = p->next;
            p->next = fileNode;
            
        }
        //在本地创建真实文件
        string Fn = filename + ".txt";
        ofstream file;
        file.open(Fn);
        file.close();
        
        cout << "文件创建成功" << endl;
    }
    else
    {
        cout << "磁块申请失败，磁盘空间已满" << endl;
    }
    
}
void ClassDesign::freeDisk(int startPostion)
{
    diskNode* p;
    for (p = diskHead; p != NULL; p = p->next)
    {
        if (p->start == startPostion)
            break;
    }
    p->useFlag = false;
}
void ClassDesign::fileDelete()
{
    string filename;
    cout << "请输入想要删除的文件名：";
    cin >> filename;
    UFD* p, * q, * temp;
    q = user[NowUser].user;
    p = q->next;
    //寻找指定文件在链表的位置
    while (p)
    {
        if (p->file->filename == filename)
            break;
        else
        {
            p = p->next;
            q = q->next;
        }
    }
    if (p)//找到
    {
        if (p->file->openflag != true)//文件不在打开状态
        {
            temp = p;
            q->next = p->next;
            freeDisk(temp->file->start);//释放所占磁块
            delete temp;
            char c[20];
            string s=filename+".txt";
            strcpy(c,s.c_str());
            remove(c);
            cout << "文件删除成功" << endl;
            
        }
        else
        {
            cout << "该文件未关闭，请关闭后重试" << endl;
        }
    }
    else
    {
        cout << "查无此文件" << endl;
    }
}
void ClassDesign::fileRead()
{
    if (FileOpen == false)
    {
        cout << "当前未打开任何文件" << endl;
        return;
    }
    string filename = Now_Filename;
    UFD* p, * q;
    q = user[NowUser].user;
    for (p = q->next; p != NULL; p = p->next)
    {
        if (p->file->filename == filename)
            break;
    }
    if (p)
    {
        //检查文件打开标志
        if(p->file->fileKind=='1')
            cout<<"该文件为只写文件，不可读取"<<endl;
        if(p->file->openflag == true)
            //找文件所对应的磁盘块
        {
            diskNode* need;
        
            //TODO 2 补充读取磁盘内容代码，并将内容输出
        }
        else
        {
            cout << "请先打开文件" << endl;
            return;
        }
    }
}
void ClassDesign::filewrite()
{
    //检测当前文件是否打开
    if (FileOpen == false)
    {
        cout << "当前未打开任何文件" << endl;
        return;
    }
    
    
    string filename = Now_Filename;
    UFD* p, * q;
    q = user[NowUser].user;
    for (p = q->next; p != NULL; p = p->next)
    {
        if (p->file->filename == filename)
            break;
    }
    if (p)
    {
        if (p->file->fileKind == '0')
        {
            cout << "该文件仅供读操作！" << endl;
            return;
        }
        if (p->file->openflag == true)
            //找文件所对应的磁盘块
        {
            diskNode* need;
            for (need = diskHead; need != NULL; need = need->next)
            {
                if (need->start == p->file->start)
                    break;
            }
            if (need)
            {
                //找到磁块，将内容写入磁块
                int l = need->maxlength;
                char* temp = new char[l];
                cin >> temp;
                int len_In = strlen(temp);//输入内容的长度
                if (len_In <= l)
                {
                    need->text = temp;
                    cout << "文件内容写入成功" << endl;
                    //往真实文件写入数据内容
                    string Fn = filename + ".txt";
                    fstream file;
                    file.open(Fn, std::ios::out | std::ios::app);
                    while (!file.is_open())
                    {
                        file.open(Fn, std::ios::out | std::ios::app);
                    }
                    file << temp;//往真实文件写入内容
                    file.close();
                    
                }
                else
                {
                    cout << "文件内容超出存储容量，存在内容丢失" << endl;
                }
            }
        }
        else
        {
            cout << "请先打开文件" << endl;
            return;
        }
    }
}
void ClassDesign::fileclose()
{
    string filename = Now_Filename;
    if (Now_Filename == "")
    {
        cout << "当前未打开文件" << endl;
    }
    UFD* p, * q;
    q = user[NowUser].user;
    for (p = q->next; p != NULL; p = p->next)
    {
        if (p->file->filename == filename)
            break;
    }
    if (p)
    {
        if (p->file->openflag == true)
        {
            p->file->openflag = false;
            FileOpen = false;
            cout << "文件关闭成功！" << endl;
        }
        else
        {
            cout << "文件早已关闭!" << endl;
        }
    }
}
void ClassDesign::fileopen()
{
    if (FileOpen == true)
    {
        cout << "当前已有打开文件，请关闭后再试" << endl;
        return;
    }
    string filename;
    cout << "请输入要打开的文件名:";
    cin >> filename;
    Now_Filename = filename;
    UFD* p, * q;
    q = user[NowUser].user;
    for (p = q->next; p != NULL; p = p->next)
    {
        if (p->file->filename == filename)
            break;
    }
    if (p)
    {
        if (p->file->openflag != true)
        {
            p->file->openflag = true;
            FileOpen = true;
            cout << "文件打开成功！" << endl;
        }
        else
        {
            cout << "文件已打开!" << endl;
        }
    }
    else
        cout<<"无此文件！"<<endl;
}
void ClassDesign::fileDir()
{
    //列文件目录，将该用户下的目录项都输出
    UFD* p = user[NowUser].user->next;
    if (!p)
        return;
    cout << "当前用户:" << user[NowUser].username << endl;
    cout << "用户目录项:" << endl;
    cout << "文件名\t\t物理地址\t保护码\t\t文件长度" << endl;
    for (p = user[NowUser].user->next; p != NULL; p = p->next)
    {
        cout << p->file->filename << "\t\t" << p->file->start << "\t\t" << p->file->protect << "\t\t" << p->file->length << endl;
    }
}
void ClassDesign::FreeSpace()
{
    UFD *p,*q;
    diskNode *tempOne,*tempTwo;
    //释放UFD链表
    for(int i = 0;i<Used;i++)
    {
    
    p = user[i].user;
        while(p)
        {
            q = p->next;
            delete(p);
            p = q;
        }
        user[i].user = NULL;
        // TODO 3 补充释放 UFD 代码
    }
    //释放磁块链表
    tempOne = diskHead;
    while(tempOne)
    {
        tempTwo = tempOne->next;
        delete tempOne->text;//先释放指针指向位置中还存在的指针指向位置
        delete tempOne;
        tempOne = tempTwo;
    }
    diskHead = NULL;
    cout<<"内存空间释放完毕"<<endl;
}
void ClassDesign::SaveData()
{
    fstream file;
    string Fn = "MFD.txt";
    file.open(Fn, std::ios::out | std::ios::app);
    while (!file.is_open())
    {
        file.open(Fn, std::ios::out | std::ios::app);
    }
    for (int i = 0; i < Used; i++)
    {
        file << user[i].username << endl;
    }
    file.close();
    UFD* p;
    for (int i = 0; i < Used; i++)
    {
        string Fn = user[i].username + ".txt";
        file.open(Fn, std::ios::out | std::ios::app);
        while (!file.is_open())
        {
            file.open(Fn, std::ios::out | std::ios::app);
        }
        //按链表查找子目录，将子目录写入文件
        for (p = user[i].user->next; p != NULL; p = p->next)
        {
            file << p->file->filename << endl;//将子目录名写入文件
        }
        file.close();
    }
    
}
int main(int argc, const char* argv[]) {
    ClassDesign os;
    os.Initdata();
    int ch = -1;
    string com;
    cout << "------------文件系统：-----------" << endl;
    cout << "-----功能：------------指令------" << endl;
    cout << "-----登录系统----------login-----" << endl;
    cout << "-----打开文件----------open-----" << endl;
    cout << "-----关闭文件----------close-----" << endl;
    cout << "-----创建文件----------creat-----" << endl;
    cout << "-----读取文件----------read------" << endl;
    cout << "-----写入文件----------write-----" << endl;
    cout << "-----删除文件----------delete----" << endl;
    cout << "-----文件目录----------dir-------" << endl;
    cout << "-----创建用户----------user------" << endl;
    cout << "-----退出系统----------exit------" << endl;
    cout << "root:>";
    while (cin >> com)
    {
        if (com == "login") { ch = 0; }
        else if (com == "open") { ch = 1; }
        else if (com == "close") { ch = 2; }
        else if (com == "creat") { ch = 3; }
        else if (com == "read") { ch = 4; }
        else if (com == "write") { ch = 5; }
        else if (com == "delete") { ch = 6; }
        else if (com == "dir") { ch = 7; }
        else if (com == "user") { ch = 9; }
        else if(com == "exit")
            ch = -1;
        else
        {
            cout<<"指令错误，请重试"<<endl;
            ch=-2;
        }
        switch (ch)
        {
            case 0:
            {
                os.login(); break;
            }
            case 1:
            {
                os.fileopen(); break;
            }
            case 2:
            {
                os.fileclose(); break;
            }
            case 3:
            {
                os.fileCreate(); break;
            }
            case 4:
            {
                os.fileRead(); break;
            }
            case 5:
            {
                os.filewrite(); break;
            }
            case 6:
            {
                os.fileDelete(); break;
            }
            case 7:
            {
                os.fileDir(); break;
            }
            case 9:
            {
                os.userCreate(); break;
            }
            default:
                break;
        }
        if (ch == -1)
            break;
        string a =os.getNowuser();
        if(a!="")
            cout<<"root:>" <<a<<"/:";
        else
            cout << "root:>";
    }
    os.SaveData();
    os.FreeSpace();
    return 0;
}
