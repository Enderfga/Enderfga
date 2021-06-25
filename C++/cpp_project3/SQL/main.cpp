#include"SQL.h"
void Line() {//分割线
    for (int i = 0; i < 80; i++)
        cout << '-';
    cout << endl;
}
int main() {
    Create();
    Line();
    SortByName(txt1);
    Line();
    SortByScore(txt2);
    Line();
    SortByID1(txt1);
    Line();
    SortByID2(txt2);
    Line();
    SortByTotalScore(TotalScore);
    Line();
    Test();
    /*查询符合条件的项：sex == ‘M’ && (birthday.year > 2017 || score < 80)，打印并删除*/
    auto sex = "Male";//以下各条件均测试通过，可作为条件参数进行Erase
    auto birthday_year = 1993, id = 10905, score = 80;
    auto d = make_tuple(1994, 2, 1);
    auto course = "C Programming Language";
    auto it = txt1.begin();
    while (it!=txt1.end())
    {//如果按照题目里的2017，就没有任何人符合条件了,故改为1900;score未指明，此处默认按照C语言
        if (Sex(*it) == sex && Year(Birthday(*it)) > 1900 || GetScore(txt2,course,ID(*it)) < 80)
            cout << *it << endl;
        it++;
    }
    Line();
    vector<Info> txt3 = Erase(txt1, sex);//删除符合sex条件
    vector<Course> txt4 = EraseCmp(smaller, txt2, score);//删除小于80分
    vector<Course> txt5 = EraseCmp(larger, txt2, score);//删除大于80分
    PrintInfo(txt3);
    Line();
    PrintCourse(txt4);
    Line();
    PrintCourse(txt5);
    Line();
    return 0;
}
