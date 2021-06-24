#include"MyVector.h"
#include"Person.h"
#include"ListQueue.h"
#include <cstdlib> //  srand and rand
#include <ctime> //  time
#include<vector>
#include<deque>
using namespace std;
int main()
{
    MyVector<Student> mv;
    Student s1("4005", "Barbara", "SYSU");
    Student s2("4006", "Vanida", "SYSU");
    Student s3("4007", "Bartola", "SYSU");
    Student s4("4008", "Brielle", "SYSU");
    Student s5("4009", "Garner", "SYSU");
    Student s6("4010", "Franklyn", "SYSU");
    Student s7("4011", "Celestyn", "SYSU");
    Student s8("4012", "Gregg", "SYSU");
    mv.push_back(s1);
    mv.push_back(s2);
    mv.push_back(s3);
    mv.push_back(s4);
    mv.insert(2, s5);
    mv.erase(2);
    mv.push_back(s6);
    mv.push_back(s7);
    mv.push_back(s8);
    mv.pop_back();
    cout << mv << mv.back() << mv.front() << mv.at(2) << endl;
    mv.clear();
    if (mv.empty())
        cout << "It is clear." << endl;//判断是否清空成功
    //int,double,string等也在MyVector中正常运行，不再额外测试
    //以下开始测试ListQueue及各接口
    unsigned seed;//提供不同的种子值，确保随机生成数
    seed = (unsigned)time(0);
    srand(seed);
    ListQueue<double> ran;
    for (int i = 0; i < 5; i++)
    {
        double tmp1 = rand(), tmp2 = rand();
        ran.push_back(tmp1);
        ran.push_front(tmp2);
    }//从前后各插入5个随机值
    cout << ran << endl;
    ran.clear();
    for (int i = 0; i < 5001; i++)
    {
        double tmp1 = rand(), tmp2 = rand();
        ran.push_back(tmp1);
        ran.push_front(tmp2);
    }//从前后各插入5001个值
    ran.pop_back();
    ran.pop_front();
    double pi = 3.1415;
    ran.insert(ran.end(),pi);
    cout << ran.at(10000) << "&" << ran[10000] <<"&"<<ran.back() << endl;
    ran.erase(ran.begin());
    for (int i = 0; i < 10000; i++)
    {
        double temp = ran[-1];
        ran.FindforErase(temp);
    }//随机访问并删除，直至被清空，类似于clear函数
    if (ran.empty())
        cout << "It is clear." << endl;//判断是否清空成功
    /*static const auto MAX = 10;
    ListQueue<MyVector<int>> list;
    for (int i = 0; i < 10; i++) {
        MyVector<int> temp;
        for (int j = 0; j < MAX; j++) {
            temp.push_back(i);
        }
        list.push_front(temp);
    }//尝试进行类模板嵌套并以MAX为上限组织对象，
    但是会导致权限访问冲突，目前还未想出解决方法
    cout << list;*/
    return 0;
}