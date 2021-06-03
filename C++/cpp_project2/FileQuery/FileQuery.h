#ifndef _FILEQUERY_H_
#define _FILEQUERY_H_
#include <iostream>
#include <memory>
#include <string>
#include <vector>
#include <map>
#include <set>
#include <fstream>
#include <sstream>
using namespace std;
//头文件中进行相关声明，具体实现在cpp源文件中
typedef pair<string, int> PAIR;
bool cmp_by_value(const PAIR& lhs, const PAIR& rhs);
//以上两行是为map按照value排序做准备
class FileQuery
{
    typedef map<string, int>::iterator mit;//迭代器重命名
public:
    FileQuery(ifstream& file);
    void PrintSentences();
    void PrintSentencesAscend();
    void PrintWordCount();
    void PrintTopWordContext(int n);
private:
    map<string, int> ma;//存储词汇及其出现次数
    mit it;//迭代器
    vector<string> sentences;//按行分割的句子
    vector<string> words;//按顺序存入的词汇
};

#endif
