#include"SQL.h"
void Line() {
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
    /*对查询并删除符合条件的项：sex == ‘M’ && (birthday.year > 2017 || score < 80)*/
    auto sex = "Male";//以下各条件均测试通过，可作为条件参数进行Erase
    int birthday_year = 1993, id = 10905, score = 80;
    date d = make_tuple(1994, 2, 1);
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
