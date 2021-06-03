# 大作业二

## 理论课题

 


要求：在gitee上建立MyShape项目，完成以下题目，提交Edge.h, Shape.h, ShapeFile.h, Shape.cpp, ShapeFile.cpp和main.cpp文件，以及运行结果的文本文件result.txt。

 

1. 定义一个点类Point，表示平面上的一个点，包含坐标double x_, double y_，提供打印功能Print()。

2. 定义一个边类Edge，包括一条边的两个Point端点，提供求长度Length()和打印Print()函数。打印函数需要重用Point类的相关打印功能。

3. 定义一个抽象基类Shape，提供周长double Circumference (), 面积double Area(), void Print()等纯虚函数，提供虚函数bool IsValid()判断是否是合法。定义静态常量static const int UnknownValue = -1。

4. Shape派生出圆类Circle，包含圆心 Point center_和半径 double radius_，Shape派生出类多边形类Polygon，包含多条边的指针，即std::vector<Edge*> edges_。

所有Shape的派生类，都提供自己的Circumference（）、Area（）、Print() 的重写实现。需要用virtual, override等关键词，如果是常函数，还需要用const。举例：virtual bool IsValid() const override {…}。对于复合形状，如果难以计算，统一返回UnknownValue。

不同派生类的Print打印内容不同：Circle需打印圆心，半径，以及面积，周长；Polygon需要打印Edge信息（调用Edge自己的Print()函数），以及面积，周长。

5. 提供操作符重载函数，支持两个Shape对象s1，s2的与和或（即交和并）操作：s1 & s2， s1 | s2，返回一个新的Shape对象或其指针。支持连续操作比如s1 & s2 | s3，生成Polygon对象或其指针返回。

用运行时类型识别接口（dynamic_pointer_cast或typeid）和对象内部属性，函数体类内，只需要处理s1和s2都是多边形或圆形的情况。

6. 实现一个ShapeFile类，通过构造函数读取一个文件shapes.txt，为每一行动态生成（new）一个Shape对象，以std::vector<Shape*> shapes_统一保存不同图形对象的指针。

为ShapeFile提供一个void Generate()函数，为提供的Shape对象两两进行&和|操作，产生新的Shape对象，如果该Shape合法，按指针存放到专门的std::vecor<Shape*> compositeShapes_ 里面。

为ShapeFile提供一个Print函数，对所有原始和新生成的Shape对象（即shapes_, composieShapes_)，通过其指针，逐一调用Print()函数。

建议使用智能指针。编写main函数，以shapes.txt文件为参数，生成一个ShapeFile的对象sfile，调用Print()，验证上述功能。

附：将如下内容保存为shapes.txt，将该文件作为程序的参数传入. #开头的行表示注释。

 

\#Prepresents Point, format: (x, y)

P1: (2,2)

P2: (3,2)

P3: (3,4)

P4: (1,2)

P5: (5,6)

P6: (4,2）

P7: (1,1)

P8: (3,3)

P9: (4,4)

P10: (4,3)

\#circle format: center, radius (int)

Circle: P6,2

Circle: P4,2

\#polygon format: sequence of vertices

Polygon: P4, P2, P3

Polygon: P1, P6, P10, P8

Polygon: P2, P6, P5, P3

 

## **实验课题**

要求：在gitee上建立FileQuery项目，完成以下题目，提交FileQuery.h, FileQuery.cpp，main.cpp文件，以及运行结果的文本文件result.txt。

 

1.实现一个类FileQuery，拥有私有成员std::vector<std::string> sentences_，实现如下功能

读取一个指定文本文件TwoCities.txt（将附录的文本拷贝至TwoCities.txt），

\* FileQuery以文件名为构造参数，读取文件，滤除回车换行符号，并提取句子（逗号或句号结尾），存储在sentences_中

\* void PrintSentences(), 打印所有的句子，每行打印一个

\* void PrintSentencesAscend() 将所有句子按字典升序排列，重新打印

\* void PrintWordCount(), 打印每个单词出现的次数，如the: 36, word: 12

\* void PrintTopWordContext(int n), 打印词频最高的n个单词，对每个单词，

打印所有该单词出现的上下文：前一个单词，本单词，下一个单词。如果前或后没有单词，就不打印该部分

 

要求:主要数据结构用STL实现,读文件可以用C或C++语言接口,可以使用vector基本类型实现,但鼓励探索更高效的类模板，支持高效的重复查询。编写main函数,以提供的TwoCities.txt为参数，构造一个FileQuery对象，实现并验证所有方法（假设n=3）。

代码越清晰简洁，程序运行越快，少冗余操作，得分越高。

 

 

附录：

It was the best of times, 

it was the worst of times, 

it was the age of wisdom, 

it was the age of foolishness, 

it was the epoch of belief, 

it was the epoch of incredulity, 

it was the season of Light,

it was the season of Darkness, 

it was the spring of hope, 

it was the winter of despair, 

we had everything before us, 

we had nothing before us, 

we were all going direct to heaven, 

we were all going direct the other way -

in short, the period was so far like the present period, 

that some of its noisiest authorities insisted on its being received, 

for good or for evil, 

in the superlative degree of comparison only.

-- Charles Dickens, A Tale of Two Cities

 
