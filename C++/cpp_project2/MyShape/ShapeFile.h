#ifndef _SHAPEFILE_H_   //防止头文件被重复包含和编译
#define _SHAPEFILE_H_
#include<iostream>
#include"Edge.h"
#include"Shape.h"
#include<fstream>//用于读取文件
#include<string>//用于字符串解析
#include<vector>
#include<memory>
using namespace std;
class ShapeFile
{
public:
    ShapeFile() //该构造函数根据shapes.txt编写，不具有普遍性
    {
        string cd1 = "#Prepresents Point, format: (x, y)";
        string cd2 = "#circle format: center, radius (int)";
        string cd3 = "#polygon format: sequence of vertices";
        //三句注释可以用来作为判断条件
        ifstream in("./shapes.txt");//读取同一根目录下的shapes.txt
        string line;
        vector<Point> ps;//储存读取的点集
        int j, k;
        j = k = 0;
        if (in.is_open()) // 有该文件
        {
            while (getline(in, line)) // line中不包括每行的换行符
            {
                if (line.find(cd1) != string::npos)
                    continue;//如果读取到第一个注释，则进入下一次循环
                if (line.find(cd2) != string::npos)
                    break;//如果读取到第二个注释，则进入下一个循环
                Point temp((line[5] - (double)'0'), ((double)line[7] - '0'));
                //将读取的字符减去'0'，且进行强制类型转换，这样即可转化为所需的数字，该方法适用于ASCII码，utf-8等
                ps.push_back(temp);
            }
            while (getline(in, line)) // line中不包括每行的换行符
            {
                if (line.find(cd2) != string::npos)
                    continue;//如果读取到第二个注释，则进入下一次循环
                if (line.find(cd3) != string::npos)
                    break;//如果读取到第三个注释，则进入下一个循环
                Circle temp(ps[((int)line[9] - '0')], ((double)line[11] - '0'));
                c.push_back(temp);
                shared_ptr<Shape> p1;
                shared_ptr<Circle> Ptr1 = make_shared<Circle>(temp);//类似读取点的方法构造shape，并将其指针存入shapes
                p1 = dynamic_pointer_cast<Shape>(Ptr1);
                shapes.push_back(p1);
            }
            int flag = 0;//只构造了一个三边形，其余为四边形，故设置了flag加以区分
            while (getline(in, line)) // line中不包括每行的换行符
            {
                if (line.find(cd3) != string::npos)
                    continue;//如果读取到第三个注释，则进入下一次循环
                vector<shared_ptr<Edge>> e;
                vector<Point> v;
                if (flag == 0)
                {
                    flag = 1;
                    v.push_back(ps[(int)line[10] - '0']);
                    v.push_back(ps[(int)line[14] - '0']);
                    v.push_back(ps[(int)line[18] - '0']);
                }
                else
                {
                    v.push_back(ps[(int)line[10] - '0']);
                    v.push_back(ps[(int)line[14] - '0']);
                    v.push_back(ps[(int)line[18] - '0']);
                    v.push_back(ps[(int)line[22] - '0']);
                }
                for (unsigned i = 0; i < v.size() - 1; i++)
                {
                    Edge tmp(v[i], v[i + 1]);
                    shared_ptr<Edge> ptr = make_shared<Edge>(tmp);
                    e.push_back(ptr);
                }//以点集构造边集，再构造shape
                Edge tmp(v.back(), v[0]);
                shared_ptr<Edge> ptr = make_shared<Edge>(tmp);
                e.push_back(ptr);//最后要将图像闭合，故循环外多一步将终点连向起点
                Polygon temp(e);
                p.push_back(temp);
                shared_ptr<Shape> p2;
                shared_ptr<Polygon> Ptr2 = make_shared<Polygon>(temp);
                p2 = dynamic_pointer_cast<Shape>(Ptr2);
                shapes.push_back(p2);//类似读取点的方法构造shape，并将其指针存入shapes
            }
        }
        else // 没有该文件
        {
            cout << "no such file" << endl;
        }
        this->Generate();//读取解析完txt文件之后，执行Generate，生成compositeShapes
    }
    ~ShapeFile() {}
    void Generate()
    {
        //将各个对象进行并和交，判断是否合法，将合法的对象push进compositeShapes中
        Circle temp;
        if ((c[0] | c[1]).IsValid())
            temp = (c[0] | c[1]);
        if ((c[0] & c[1]).IsValid())
            temp = (c[0] & c[1]);
        shared_ptr<Shape> p1;
        shared_ptr<Circle> Ptr1 = make_shared<Circle>(temp);
        p1 = dynamic_pointer_cast<Shape>(Ptr1);
        compositeShapes.push_back(p1);
        for (unsigned i = 0; i < p.size(); i++)
            for (unsigned j = i + 1; j < p.size(); j++)
            {
                Polygon temp;
                if ((p[i] | p[j]).IsValid())
                {
                    temp = (p[i] | p[j]);
                    shared_ptr<Shape> p2;
                    shared_ptr<Polygon> Ptr2 = make_shared<Polygon>(temp);
                    p2 = dynamic_pointer_cast<Shape>(Ptr2);
                    compositeShapes.push_back(p2);
                }

                if ((p[i] & p[j]).IsValid())
                {
                    temp = (p[i] & p[j]);
                    shared_ptr<Shape> p2;
                    shared_ptr<Polygon> Ptr2 = make_shared<Polygon>(temp);
                    p2 = dynamic_pointer_cast<Shape>(Ptr2);
                    compositeShapes.push_back(p2);
                }
            }
        //双层循环，让所有shapes成员都互相交或并
    }
    void Print()
    {
        for (unsigned i = 0; i < shapes.size(); i++)
            shapes.at(i)->Print();
        for (unsigned i = 0; i < compositeShapes.size(); i++)
            compositeShapes.at(i)->Print();
        //将shapes，compositeShapes所有指针成员调用对应的print函数打印
    }
private:
    vector<shared_ptr<Shape>> shapes;
    vector<shared_ptr<Shape>> compositeShapes;
    vector<Circle> c;//事先将Circle/Polygon用vector存储，便于Generate
    vector<Polygon> p;
};
#endif