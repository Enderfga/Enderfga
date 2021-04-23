# 大作业一

提交截止时间2021年4月23日（周五）之前

要求建立gitee项目，cpp_project1 (和gitee教程pdf里不一样， 以这里为准)，提交三个cpp文件，student.cpp，pointvector.cpp，sparse_matrix.cpp，分别完成三道大题。

 

## 理论课大作业

 

### **1.** Student项目

 

建立Student类，包含如下成员：

int id;

std::string name;

std::string courseNames[maxCourses]

double grades[maxCourses]

通过静态常变量定义最大课程数 maxCourses 为3



要求实现以下功能:

默认/非默认构造函数

拷贝构造函数，要求用常引用作为形参（保护原始对象不被改变）

对id和name的存取函数，要求对于不修改数据成员的函数添加const保护



实现以下函数

bool AddCourse(const std::string& courseName, double grade)  //返回是否成功

void SetGrade()      //形参数课程名，分数，仿照上面的声明

double GetGrade() const //形参为课程名

double GetAverageGrade() const

void ShowGrades() const



Student包含一个友元类StudentClass，要求定义和实现以下类功能

通过静态常变量定义最大学生数 maxStudents 为20

通过静态变量保持学生对象个数studentCount

 

std::string code;   //如: ise201901

Student* students[maxStudents];

 

实现以下功能

默认/非默认/拷贝构造函数（常引用），析构函数（注意清理内存）

存取函数（注意常函数使用）

bool AddStudent（const Student *student)

void ShowStudent(int id) const 函数

void ShowStudentsByIdOrder(bool (*compare)(int, int)) 函数

static void showStudentCount()函数

 

main.cpp

代码中，手工初始化3门课程(Robotics, C++, Math)，3个学生(Bob, John, Alice)各自的分数，展示所有函数的用例，包括打印所有学生情况；

提供bool ascending(int, int)和bool descending(int, int)函数，分别作为函数指针传递给ShowStudentsByIdOrder，对学生进行升、降序排列。

 

 

 

### 2.PointVector项目

 

struct Point {

Point(int x = 0, int y = 0) : x(x), y(y){}

void print() { std::cout << "(" << x << "," << y << ")";}

int x; 

int y;

};

实现一个PointVector，参考std::vector的一些基本特性

数据成员包括（但不限于）：

Point *data; 

unsigned size; //元素个数

unsigned capacity；//分配的空间大小（包括预留空间）

构造函数：

默认构造 PointVector ();

拷贝构造 PointVector (const PointVector& x); //注意深度复制

析构函数 ~PointVector()

实现操作符重载：=（深度赋值）, +, 流输出<<，下标[]

实现方法：

clear() //清空向量

void push_back(const Point&) //加入一个元素

void pop_back() //删去最后一个元素

Point & at(unsigned idx) //返回第idx个元素的引用

unsigned size() //返回元素个数

unsigned capacity() //容量

bool empty() //vector是否空

Point &front() //返回头一个元素的引用

Point &back() //返回最后一个元素

bool insert(unsigned pos, const Point &pt) //pos之前插入一个Point对象

bool erase(unsigned pos) //删除pos位置的对象

提供主函数，提供以下类似的测试代码（未经调试）：



PointVector pvec;

if(pvec.empty()) printf("empty point vector!\n");

for(int i = 0; i < 20; i++) {

pvec.push_back(Point(i, i));

std::cout << "size = " << pvec.size() << ", capacity = " << pvec.capacity() << std::endl;

}

pvec.front().print();

pvec.back().print();

PointVector pvec1(pvec);

std::cout << pvec1;

PointVector pvec2;

pvec2 = pvec1;

for(unsigned j = 0; j < pvec2.size(); j++){

std::cout << pvec2.at(j).x << " " << pvec2[j].y << std::endl;

}

pvec.insert(0，Point(100, 100));

std::cout << pvec << std::endl;;

pvec.erase(pvec.size()/2);

std::cout << pvec << std::endl;

std::cout << pvec1 + pvec2 << std::endl;



 

## 实验课大作业

 

### **1.** SparseMatrix项目

 

模仿课堂上讲的Matrix类，建立稀疏矩阵类（稀疏矩阵指矩阵中大部分元素为0）SparseMatrix。私有成员包括矩阵行、列数, 以及非零元素数组struct NonzeroElement {int row; int col; double value} *data；比如： 

![img](file:///C:\Users\User\AppData\Local\Temp\ksohtml12604\wps1.jpg) 

1. 默认构造函数，构造函数 （参数为Matrix对象），析构函数，（深度）复制构造函数，（深度）赋值运算符，

2. 定义矩阵相加/相减函数add/subtract，如m1.add(m2)，修改m1本身的值

3. 输出函数，按照矩阵的形式输出到显示屏

4. 重载+, -, <<运算符

5. 提供get和set成员函数，参数是行列的序号。注意会涉及data数组的增删

 

编写主函数测试所有功能。采用上面图示例子。

以加法为例：

![img](file:///C:\Users\User\AppData\Local\Temp\ksohtml12604\wps2.jpg) 