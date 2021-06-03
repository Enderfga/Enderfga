#include"FileQuery.h"
#include<iostream>
#include<algorithm>
#include<functional>
#include<fstream>
#include<map>
#include<sstream>
#include<string>
using namespace std;

bool cmp_by_value(const PAIR& lhs, const PAIR& rhs)
{
    return lhs.second > rhs.second;
}
//map默认用key排序，故通过该函数进行value排序（“>”为升序，反之降序）

FileQuery::FileQuery(ifstream& file)
{
    string str;//存“行”字符串
    string st;//存“词”字符串
    while (getline(file, str))
    {
        sentences.push_back(str);
        istringstream ist(str);
        while (ist >> st)
        {
            string::size_type idx1;
            string::size_type idx2;
            idx1 = st.find(',');
            idx2 = st.find('.');
            if (idx1 != string::npos || idx2 != string::npos)
                st = st.substr(0, st.length() - 1);//如果读取到句话或者逗号则将其消除
            words.push_back(st);
            it = ma.find(st);
            if (it != ma.end())
                ++(*it).second;//记录词频
            else
                ma[st] = 1;
        }
    }
}
void FileQuery::PrintSentences()
{
    for (unsigned i = 0; i < sentences.size(); i++)
        cout << sentences.at(i) << endl;
}
void FileQuery::PrintSentencesAscend()
{
    sort(sentences.begin(), sentences.end(), less<string>());
    //less<string>()封装于functional中，用于string的升序排列
    for (unsigned i = 0; i < sentences.size(); i++)
        cout << sentences.at(i) << endl;
}
void FileQuery::PrintWordCount()
{
    //利用迭代器将map中的key（词汇）和value（频率）打印出来
    for (it = ma.begin(); it != ma.end(); ++it)
        cout << (*it).first << ":" << (*it).second << endl;
}
void FileQuery::PrintTopWordContext(int n)
{
    vector<PAIR> ma(ma.begin(), ma.end());//将map先转换为vector
    sort(ma.begin(), ma.end(), cmp_by_value);//利用事先写好的函数排序
    for (int i = 0; i < n; ++i)  //输出前n个词频最高词汇
    {
        cout << ma[i].first << ":" << ma[i].second << endl;
        int flag = 1;//循环起始标志
        int j = 1;//词汇出现位置的序号
        vector<string>::iterator begin = words.begin();
        while (flag)
        {
            auto index = find(begin, words.end(), ma[i].first);
            if (index != words.end())
            {
                cout << j << "  前一个单词：" << *(index - 1) << " ; "  << "后一个单词：" << *(index + 1) << endl;
                begin = index + 1;//从下一个位置开始继续寻找所查词汇
                j++;
            }
            else
            {
                flag = 0;//flag为0，循环结束
            }
        }
    }
}

