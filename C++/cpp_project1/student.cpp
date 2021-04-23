#include <iostream>
#include <string>
using namespace std;
class Student
{
public:
    Student()   //默认构造函数，将所有成绩初始化为-1，课程名为空字符
    {
        for (int i = 0; i < maxCourses; i++)
        {
            grades[i] = -1;
            courseNames[i] = "\0";
        }
    }
    Student(const int id, const string name) : id(id), name(name)  //构造函数，用对应的参数初始化
    {
        for (int i = 0; i < maxCourses; i++)
        {
            grades[i] = -1;
            courseNames[i] = "\0";
        }
    }
    Student(const Student& s)   //拷贝构造函数（注意深度复制）
    {
        this->id = s.id;
        this->name = s.name;
        for (int i = 0; i < maxCourses; i++)
        {
            courseNames[i].append(s.courseNames[i]);
            grades[i] = s.grades[i];
        }
    }
    Student operator=(const Student& s)  //“=”运算符重载，内部实现参考拷贝构造函数
    {
        if (this == &s)
            return *this;

        this->id = s.id;
        this->name = s.name;
        for (int i = 0; i < maxCourses; i++)
        {
            courseNames[i].append(s.courseNames[i]);
            grades[i] = s.grades[i];
        }

        return *this;
    }
    void SetId(int i)  //设置id
    {
        id = i;
    }
    int GetId()const   //获取id（添加const保护）
    {
        return id;
    }
    void SetName(string n)    //设置name
    {
        name = n;
    }
    string GetName()const    //获取name（添加const保护）
    {
        return name;
    }
    bool AddCourse(const string& courseName, double grade)
    {
        for (int i = 0; i < maxCourses; i++)
        {
            if (grades[i] == -1)    //如果成绩为-1，即课程为空，添加课程与成绩
            {
                courseNames[i].append(courseName);
                grades[i] = grade;
                return true;    //添加成功，函数结束
            }
            else continue;     //若不为-1，即已经设置好课程与成绩，进行下一次循环
        }
        return false;     //循环结束还未添加，则课程已满，添加失败
    }
    void SetGrade(const string& courseName, double grade)
    {
        for (int i = 0; i < maxCourses; i++)
        {
            if (courseNames[i] == courseName)   //遍历寻找对应课程设置成绩
            {
                grades[i] = grade;
                break;                          //设置完成后跳出循环，函数结束
            }
            else continue;
        }
    }
    double GetGrade(const string& courseName)const  //获取成绩（添加const保护）
    {
        for (int i = 0; i < maxCourses; i++)
        {
            if (courseNames[i] != courseName)
            {
                return grades[i];
            }
            else continue;
        }
        return 0;
    }
    double GetAverageGrade()const     //获取平均成绩（添加const保护）
    {
        int count = 0;//计算该学生已有课程数
        double sum = 0;//计算该学生已有成绩总和
        for (int i = 0; i < maxCourses; i++)
        {
            if (grades[i] != -1)
            {
                sum += grades[i];
                count++;
            }
            else break;
        }
        if (count == 0)   //若课程为0，返回平均成绩0
            return 0;
        else
            return sum / (1.0 * count);//根据sun和count计算平均成绩并返回
    }
    void ShowGrades()const    //展示学生成绩（添加const保护）
    {
        cout << name << " " << id << endl;
        for (int i = 0; i < maxCourses; i++)
        {
            if (grades[i] != -1)//通过-1判断是否拥有这门课和成绩
                cout << courseNames[i] << ":" << grades[i] << endl;
            else break;
        }
    }

private:
    static const int maxCourses = 3;  //通过静态常变量定义最大课程数 maxCourses 为3
    int id;
    string name;
    string courseNames[maxCourses];
    double grades[maxCourses];
    friend class StudentClass;    //友元类StudentClass
};
class StudentClass
{
public:
    StudentClass()        //默认构造函数，班级code为空字符，所有student指向nullptr
    {
        code = "\0";
        for (int i = 0; i < maxStudents; i++)
        {
            students[i] = nullptr;
        }
    }
    StudentClass(const string code) : code(code)  //构造函数，用参数code初始化，所有student指向nullptr
    {
        for (int i = 0; i < maxStudents; i++)
        {
            students[i] = nullptr;
        }
    }
    StudentClass(const StudentClass& sc)  //复制构造函数，使用深度复制
    {
        code = sc.code;
        for (int i = 0; i < maxStudents; i++)
            students[i] = sc.students[i];
    }
    ~StudentClass()
    {
        for (int i = 0; i < maxStudents; i++)
        {
            if (students[i] != nullptr)//如果该学生不指向nullptr，析构时要将学生数－1
                studentCount--;
            delete students[i];
        }
    }
    void SetCode(string c) //设置班级code
    {
        code = c;
    }
    string GetCode()const //获取code（添加const保护）
    {
        return code;
    }
    bool AddStudent(const Student* student)
    {
        for (int i = 0; i < maxStudents; i++)
        {
            if (students[i] == nullptr)
            {
                students[i] = new Student(*student);//添加学生，并开辟一段空间
                studentCount++;  //添加学生成功，学生数应+1
                return true;//添加成功，函数结束
            }
        }
        return false;//循环结束，添加失败
    }
    void ShowStudent(int id)const//展示学生信息（添加const保护）
    {
        for (int i = 0; i < maxStudents; i++)
        {
            if (students[i]->id == id)//通过id遍历查找对应学生，调用Student类中的ShowGrades函数
            {
                students[i]->ShowGrades();
                break;//展示结束，跳出循环，函数结束
            }
        }
    }
    void ShowStudentsByIdOrder(bool(*compare)(int, int))
    {
        int k;
        Student* temp;
        for (int i = 0; i < studentCount - 1; ++i)//冒泡排序
        {
            k = i;
            for (int j = i + 1; j < studentCount; ++j)
            {
                if ((*compare)(students[j]->id, students[k]->id))//该函数的关键，决定了升序还是降序
                {
                    k = j;
                }
            }
            if (k != i)
            {
                temp = students[k];
                students[k] = students[i];
                students[i] = temp;
            }
        }
        cout << "In the order specified：" << endl;//按照指定顺序打印学生相关信息
        for (int i = 0; i < studentCount; ++i)
        {
            cout << students[i]->name << endl;
        }
    }
    static void showStudentCount()   //静态函数，打印当前学生个数
    {
        cout << "studentCount = " << studentCount << endl;
    }
private:
    static const int maxStudents = 20;
    static int studentCount;
    string code;
    Student* students[maxStudents];
};
int StudentClass::studentCount = 0;
bool ascending(int i1, int i2)//升序bool函数
{
    return i1 < i2;
}
bool descending(int i1, int i2)//降序bool函数
{
    return i1 > i2;
}
int main()
{
    Student s1(4001, "Bob");
    s1.AddCourse("Robotics", 95);
    s1.AddCourse("C++", 92);
    s1.AddCourse("Math", 89);
    Student s2(s1);
    s2.SetId(4003);
    s2.SetName("John");
    s2.SetGrade("Robotics", 88);
    s2.SetGrade("C++", 90);
    s2.SetGrade("Math", 91);
    Student s3;
    s3.SetId(4002);
    s3.SetName("Alice");
    s3.AddCourse("Robotics", 99);
    s3.AddCourse("C++", 98);
    s3.AddCourse("Math", 87);
    cout << "----------------" << endl;//分割线，分版块展示各个函数
    cout << s3.GetName() << " :" << s3.GetId() << " :" << "C++ :" << s3.GetGrade("C++") << endl;
    cout << "----------------" << endl;
    s1.ShowGrades();
    cout << s1.GetName() << " :" << "AverageGrade :" << s1.GetAverageGrade() << endl;
    cout << "----------------" << endl;
    s2.ShowGrades();
    cout << s2.GetName() << " :" << "AverageGrade :" << s2.GetAverageGrade() << endl;
    cout << "----------------" << endl;
    s3.ShowGrades();
    cout << s3.GetName() << " :" << "AverageGrade :" << s3.GetAverageGrade() << endl;
    cout << "--------------------------------" << endl;//分割线，至此测试完Student类所有内容
    StudentClass sc1;
    StudentClass sc2("zngc1");
    StudentClass sc3(sc2);
    sc1.SetCode("zngc2");
    sc3.SetCode("znhc3");
    cout << "Class code list：" << sc2.GetCode() << "," << sc1.GetCode() << "," << sc3.GetCode() << "," << endl;
    cout << "----------------" << endl;
    sc2.AddStudent(&s1);
    sc2.AddStudent(&s2);
    sc2.AddStudent(&s3);
    sc2.showStudentCount();
    cout << "----------------" << endl;
    Student s4;
    s4 = s1;
    s4.SetName("Enderfga");
    s4.SetId(4004);
    sc2.AddStudent(&s4);
    sc2.ShowStudent(4004);
    cout << "----------------" << endl;
    sc2.showStudentCount();
    cout << "----------------" << endl;
    sc2.ShowStudentsByIdOrder(ascending);
    cout << "----------------" << endl;
    sc2.ShowStudentsByIdOrder(descending);
    cout << "----------------" << endl;//至此测试完StudentClass类的所有内容
    return 0;
}