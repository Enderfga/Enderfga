#pragma once
#define _CRT_SECURE_NO_WARNINGS
#pragma warning(disable:6031)//使用sscanf防止误报
#include<iostream>
#include<stdio.h>
#include<tuple>//元组可以存入多个数据
#include<vector>
#include<fstream>
#include<string>
#include<iomanip>//格式化输出，使列表排版美观
#include<map>//记录总分，学分
#include<algorithm>//排序和查询
using namespace std;
//定义较简单的类型名，使代码更简洁
typedef tuple<int, int, int> date;
typedef tuple<int, string, string, date, int, string> Info;
typedef tuple<int, string, float, int> Course;
typedef pair<int, int> PAIR;
//用宏定义一个标识符
#define ID get<0>
#define Courses get<1>
#define Credits get<2>
#define Score get<3>
#define Name get<1>
#define Sex get<2>
#define Birthday get<3>
#define School_year get<4>
#define Birthplace get<5>
#define Year get<0>
#define Month get<1>
#define Day get<2>
vector<Info> txt1;
vector<Course> txt2;
map<int, int> TotalScore;
map<int, float> TotalCredit;
map<int, int> Count;
//全局变量
ostream& operator<<(std::ostream& u, const date& d)
{
    u << get<0>(d) << '/' << get<1>(d) << '/' << get<2>(d);
    return u;
}
ostream& operator<<(std::ostream& u, const Info& d)
{
    u << ID(d) << '\t' << fixed << setw(12) << left << Name(d) << fixed << setw(12) << left << Sex(d) << Birthday(d) << '\t' << fixed << setw(8) << School_year(d) << '\t' << Birthplace(d);
    return u;
}
ostream& operator<<(std::ostream& u, const Course& d)
{
    u << ID(d) << '\t' << setw(25) << setiosflags(ios::left) << setfill(' ') << Courses(d) << ' ' << (int)Credits(d) << "     " << Score(d);
    return u;
}
//重载输出流，且注意排版
bool operator==(date a, date b)
{
    if (get<0>(a) == get<0>(b) && get<1>(a) == get<1>(b) && get<2>(a) == get<2>(b))
        return true;
    else return false;
}
//重载运算符，便于后续比较
char* Delete(char* a)//解决额外读入了/t的问题
{
    char* p = a;
    while (*p)
        p++;
    *(p - 1) = '\0';
    return a;
}
//两个print函数能将内容写入txt，但排版会乱
//将cout改为out即可使每次打印的内容写入txt
void PrintInfo(vector<Info> txt1)
{
    ofstream out("result.txt", ios::app);
    for (auto it = txt1.begin(); it != txt1.end(); it++)
    {
        if (it == txt1.begin())
            cout << "ID" << '\t' << fixed << setw(12) << left << "Name" << fixed << setw(12) << left << "Sex" << "Birthday" << '\t' << "School_year" << '\t' << "Birthplace" << endl;
        cout << (*it) << endl;
    }
    out.close();
}
void PrintCourse(vector<Course> txt2)
{
    ofstream out("result.txt", ios::app);
    for (auto it = txt2.begin(); it != txt2.end(); it++)
    {
        if (it == txt2.begin())
            cout << "ID" << '\t' << setw(23) << setiosflags(ios::left) << setfill(' ') << "Course" << "Credits" << '\t' << "Score" << endl;
        cout << (*it) << endl;
    }
    out.close();
}
//各种类型的cmp函数，用于Sort
bool cmp_by_value(const PAIR& lhs, const PAIR& rhs)
{
    return lhs.second < rhs.second;
}
bool cmpID1(const Info a, const Info b)
{
    return ID(a) < ID(b);// 此为升序,降序同理
}
bool cmpID2(const Course a, const Course b)
{
    return ID(a) < ID(b);
}
bool cmpName(const Info a, const Info b)
{
    return Name(a) < Name(b);
}
bool cmpScore(const Course a, const Course b)
{
    return Score(a) < Score(b);
}
void SortByID1(vector<Info> txt1)
{
    sort(txt1.begin(), txt1.end(), cmpID1);
    PrintInfo(txt1);
}
void SortByID2(vector<Course> txt2)
{
    sort(txt2.begin(), txt2.end(), cmpID2);
    PrintCourse(txt2);
}
void SortByName(vector<Info> txt1)
{
    sort(txt1.begin(), txt1.end(), cmpName);
    PrintInfo(txt1);
}
void SortByScore(vector<Course> txt2)
{
    sort(txt2.begin(), txt2.end(), cmpScore);
    PrintCourse(txt2);
}
void SortByTotalScore(map<int, int> TS)
{
    vector<PAIR> Vm(TS.begin(), TS.end());
    sort(Vm.begin(), Vm.end(), cmp_by_value);
    ofstream out("result.txt", ios::app);
    for (auto it = Vm.begin(); it != Vm.end(); it++)
    {
        if (it == Vm.begin())
            cout << "ID" << '\t' << "TotalScore" << endl;
        cout << (*it).first << '\t' << (*it).second << endl;
    }
    out.close();
}
void Create()
{
    ifstream in1("./StudentInfo.txt");
    string line;
    if (in1.is_open()) // 有该文件
    {
        while (getline(in1, line)) // line中不包括每行的换行符
        {
            if (line[0] == '#')
                continue;//跳过第一行
            int id, school_year;
            int year, month, day;//利用sccanf解析字符串，构造对象
            char name[20], sex[20], birthday[20] = { 0 }, birthplace[20];
            sscanf(line.c_str(), "%d %s %s %s %d %s", &id, name, sex, birthday, &school_year, birthplace);
            sscanf(birthday, "%4d/%1d/%1d", &year, &month, &day);
            date d;
            d = make_tuple(year, month, day);
            Info temp;
            temp = make_tuple(id, name, sex, d, school_year, birthplace);
            txt1.push_back(temp);
        }
        sort(txt1.begin(), txt1.end(), cmpID1);//默认按照id排序
    }
    ifstream in2("./StudentCourse.txt");
    if (in2.is_open()) // 有该文件
    {
        while (getline(in2, line)) // line中不包括每行的换行符
        {
            if (line[0] == '#')
                continue;//跳过第一行
            int id, score;
            float credits;
            char course[25];//利用sccanf解析字符串，构造对象
            sscanf(line.c_str(), "%d %[^1-9] %f %d", &id, course, &credits, &score);
            //由于课程名长短不一，中间包含空格数也不一样，故设置读取到数字为止，但也因此最后多读入了\t
            Course temp;
            TotalCredit[id] += credits;
            TotalScore[id] += score;//记录总学分和课程总分
            Count[id] += 1; //记录学习课程数
            temp = make_tuple(id, Delete(course), credits, score);
            txt2.push_back(temp);
        }
        sort(txt2.begin(), txt2.end(), cmpID2);//默认按照id排序
    }
}
void Test()
{
    ofstream out("result.txt", ios::app);
    out << "(a) 打印2018级选修C语言且成绩小于60分的学生:" << endl;
    for (auto it1 = txt1.begin(); it1 != txt1.end(); it1++)
    {
        if (School_year(*it1) == 2018)
            for (auto it2 = txt2.begin(); it2 != txt2.end(); it2++)
            {
                if (ID(*it1) == ID(*it2) && Courses(*it2) == "C Programming Language" && Score(*it2) < 60)
                    out << (*it1) << " ; " << (*it2) << endl;
            }

    }
    out << "(b) 统计课程平均分大于80的学生个人信息并输出:" << endl;
    for (auto it = txt1.begin(); it != txt1.end(); it++)
    {
        int tmp = TotalScore[ID(*it)] / Count[ID(*it)];
        if (tmp > 80)
            out << (*it) << " 平均分：" << tmp << endl;
    }
    out << "(c) 查询每个学生是否修满20学分:" << endl;
    for (map<int, float>::reverse_iterator it = TotalCredit.rbegin(); it != TotalCredit.rend(); it++)
    {
        if (it->second > 20)
            out << "学号为：" << it->first << "的学生修满了20学分" << endl;
    }/*事实上经过检查表上并没有修满20学分的人*/
    out.close();
}
//Info重载了多种==，便于各种条件查询
bool operator==(Info i, int x)
{
    int int1, int2;
    date d;
    tie(int1, ignore, ignore, d, int2, ignore) = i;
    if (int1 == x)
        return true;
    else if (int2 == x)
        return true;
    int year, month, day;
    tie(year, month, day) = d;
    if (year == x)
        return true;
    else if (month == x)
        return true;
    else if (day == x)
        return true;
    else return false;
}
bool operator>(Info i, int x)
{
    int int1, int2;
    tie(int1, ignore, ignore, ignore, int2, ignore) = i;
    if (int1 > x)
        return true;
    else if (int2 > x)
        return true;
    else return false;
}
bool operator<(Info i, int x)
{
    int int1, int2;
    tie(int1, ignore, ignore, ignore, int2, ignore) = i;
    if (int1 < x)
        return true;
    else if (int2 < x)
        return true;
    else return false;
}
bool operator==(Info i, string x)
{
    string str1, str2, str3;
    tie(ignore, str1, str2, ignore, ignore, str3) = i;
    if (str1 == x)
        return true;
    else if (str2 == x)
        return true;
    else if (str3 == x)
        return true;
    else return false;
}
bool operator==(Info i, date x)
{
    date d;
    tie(ignore, ignore, ignore, d, ignore, ignore) = i;
    if (d == x)
        return true;
    else return false;
}
//Course重载符号主要是为了分数的比较
bool operator>(Course c, int x)
{
    int s;
    tie(ignore, ignore, ignore, s) = c;
    if (s > x)
        return true;
    else return false;
}
bool operator<(Course c, int x)
{
    int s;
    tie(ignore, ignore, ignore, s) = c;
    if (s < x)
        return true;
    else return false;
}
bool operator==(Course c, int x)
{
    int s;
    tie(ignore, ignore, ignore, s) = c;
    if (s == x)
        return true;
    else return false;
}
//该函数可以从Info表的ID和课程查到对应的分数
int GetScore(vector<Course> t,string c,int id) {
    auto it = t.begin();
    while (it!=t.end())
    {
        if (ID(*it) == id&& Courses(*it)==c)
            return Score(*it);
        it++;
    }
    return -1;
}
//Erase函数两种vector均可使用，用于删除==条件
template<typename T1, typename T2>
T1 Erase(T1 txt, T2 cd)
{
    auto itr = txt.begin();
    while (itr != txt.end())
    {
        if (*itr == cd)
        {
            itr = txt.erase(itr);
        }

        else
            itr++;
    }
    return txt;
}
//EraseCmp函数用于Course的分数删除，可传入>,<,==三种函数指针作为参数
template<typename T1, typename T2>
T1 EraseCmp(bool(*compare)(Course, T2), T1 txt, T2 cd)
{
    auto itr = txt.begin();
    while (itr != txt.end())
    {
        if ((*compare)(*itr, cd))
        {
            itr = txt.erase(itr);
        }

        else
            itr++;
    }
    return txt;
}
//三种函数指针作为Erase函数的参数
template<typename T1, typename T2>
bool larger(T1 i1, T2 i2)
{
    return i1 > i2;
}
template<typename T1, typename T2>
bool smaller(T1 i1, T2 i2)
{
    return i1 < i2;
}
template<typename T1, typename T2>
bool equal(T1 i1, T2 i2)
{
    return i1 == i2;
}