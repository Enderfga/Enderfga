#ifndef _EDGE_H_   //防止头文件被重复包含和编译
#define _EDGE_H_
#include<iostream>
#include<cmath>   //后续计算长度会用到
#include<memory>
using namespace std;
class Point
{
public:
    Point()
    {
        this->x = 0;
        this->y = 0;
    }
    Point(double x_, double y_)
    {
        this->x = x_;
        this->y = y_;
    }
    Point(const Point& p)
    {
        this->x = p.x;
        this->y = p.y;
    }
    ~Point() {} //以上为有无参数的构造函数，复制构造函数和析构函数，无需析构内容故为空
    virtual void Print() const
    {
        cout << "(" << x << "," << y << ")";
    }//按照（x，y）的形式打印出来
    Point operator=(const Point& p)
    {
        this->x = p.x;
        this->y = p.y;
        return*this;
    }
    void set(double x_, double y_)
    {
        this->x = x_;
        this->y = y_;
    }
    double getx() const
    {
        return this->x;
    }
    double gety() const
    {
        return this->y;
    }//两个get函数方便后续获取x，y坐标
    bool operator!=(const Point& p) const
    {
        if (this->x != p.x)
            return true;
        else if (this->y != p.y)
            return true;
        return false;
    }
    bool operator==(const Point& p) const
    {
        if (this->x == p.x)
            if (this->y == p.y)
                return true;
        return false;
    }//两个运算符重载便于后续图形是否合法判断
protected:
    double x;
    double y;
};
class Edge : public Point
{
public:
    Edge()
    {
        Point p1;
        Point p2;
    }
    Edge(Point p1_, Point p2_)
    {
        this->p1 = p1_;
        this->p2 = p2_;
    }
    Edge(const Edge& e)
    {
        this->p1 = e.p1;
        this->p2 = e.p2;
    }
    ~Edge() {} //以上为有无参数的构造函数，复制构造函数和析构函数，无需析构内容故为空
    Edge operator=(const Edge& e)
    {
        this->p1 = e.p1;
        this->p2 = e.p2;
        return *this;
    }
    void set(Point p1_, Point p2_)
    {
        this->p1 = p1_;
        this->p2 = p2_;
    }
    void Print() const  override
    {
        cout << "The edge is from ";
        p1.Print();
        cout << " to ";
        p2.Print();
        cout << endl;
    }//按照“The edge is from （x，y）to（x，y）打印
    double getlen() const
    {
        return sqrt(pow((p1.getx() - p2.getx()), 2) + pow((p1.gety() - p2.gety()), 2));
    }//计算该边的长度
    void Length() const
    {
        cout << "The length of this edge is " << this->getlen() << endl;
    }//展示该边的长度
    Point getp1() const
    {
        return this->p1;
    }
    Point getp2() const
    {
        return this->p2;
    }//两个get函数方便获取坐标，为后续计算面积做准备
private:
    Point p1;
    Point p2;
};
#endif