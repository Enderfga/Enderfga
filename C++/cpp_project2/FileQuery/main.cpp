#include "FileQuery.h"
#include <fstream>
#include <iostream>
using namespace std;
int main()
{
    string filename = "./TwoCities.txt";
    ifstream inputfile(filename);
    FileQuery text(inputfile);
    cout << "以下是按行打印出来的原文" << endl;
    text.PrintSentences();
    cout << "以下是升序排列后按行打印出来的内容" << endl;
    text.PrintSentencesAscend();
    cout << "以下是所有词汇及其出现次数" << endl;
    text.PrintWordCount();
    cout << "以下是出现次数最多的前n个词及上下文" << endl;
    text.PrintTopWordContext(3);
}