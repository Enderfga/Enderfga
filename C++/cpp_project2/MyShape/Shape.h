#ifndef _SHAPE_H_   //防止头文件被重复包含和编译
#define _SHAPE_H_
#include<iostream>
#include<cmath>//计算面积周长需要使用
#include"Edge.h"
#include<vector>
#include<memory>
constexpr double pi = 3.1415926;//限定在编译期的常量π
using namespace std;
class Shape
{
public:
    Shape() {}
    ~Shape() {}
    virtual double Circumference() const = 0;
    virtual double Area() const = 0;
    virtual void Print() const = 0;
    virtual bool IsValid()const
    {
        return UnknownValue;
    }
protected:
    static const int UnknownValue = -1;
};//只有纯虚函数，虚函数的抽象类shape
class Circle : public Shape
{
public:
    Circle()
    {
        Point center;
        this->radius = 0.0;
    }
    Circle(Point p, double r)
    {
        this->center = p;
        this->radius = r;
        if (!this->IsValid())
            cout << "Warning,your shape is invalid. " << endl;//构造之后进行合法性判断
    }
    Circle(const Circle& c)
    {
        this->center = c.center;
        this->radius = c.radius;
    }
    ~Circle() {} //以上为有无参数的构造函数，复制构造函数和析构函数，无需析构内容故为空
    double Circumference() const  override
    {
        if (!this->IsValid())
            return UnknownValue; //若不合法，返回-1
        return 2 * pi * radius;
    }//按照面积公式计算
    double Area() const  override
    {
        return pi * pow(radius, 2);    //按照周长公式计算
    }
    void set(Point p, double r)
    {
        this->center = p;
        this->radius = r;
    }
    void Print() const  override
    {
        if (this->IsValid())
        {
            printf("This is a circle with a radius of %f at the center of ", radius);
            center.Print();
            cout << " The circumference is: " << Circumference() << ",the area is: " << Area() << endl;
        }//若合法，打印出所有图形信息：圆心，半径，周长，面积
    }
    virtual bool IsValid()const override
    {
        if (radius > 0)
            return true;
        else return false;
    }//圆形以半径是否大于0为判断合法与否标准
    Circle operator&(const Circle& c)
    {
        if (typeid(*this) == typeid(c)) //判断是否为同一类
        {
            Point center_(0.5 * (this->center.getx() + c.center.getx()), 0.5 * (this->center.gety() + c.center.gety()));
            Edge diam(this->center, c.center);
            if (diam.getlen() < (this->radius + c.radius))
            {
                Circle result;
                return result;
            }
            Circle result(center_, 0.5 * diam.getlen());
            return result;
        }
        Circle result;
        return result;
    }
    Circle operator|(const Circle& c)
    {
        if (typeid(*this) == typeid(c)) //判断是否为同一类
        {
            Point center_(0.5 * (this->center.getx() + c.center.getx()), 0.5 * (this->center.gety() + c.center.gety()));
            Edge diam(this->center, c.center);
            if (diam.getlen() >= (this->radius + c.radius))
            {
                Circle result;
                return result;
            }
            Circle result(center_, 0.5 * diam.getlen());
            return result;
        }
        Circle result;
        return result;
    }//圆形的并和交都返回了以两圆心为端点的直径d的圆，区别在于并必须d>r1+r2 交必须d<r1+r2
private:
    Point center;
    double radius;
};
double LinearIntegration(const Point& p1, const Point& p2)
{
    return 0.5 * (p2.getx() - p1.getx()) * (p2.gety() + p1.gety());
}//该函数非类内成员函数，用于辅助计算n边形面积
class Polygon : public Shape
{
public:
    Polygon()
    {
        vector<shared_ptr<Edge>> edges;
        sides = edges.size();
    }
    Polygon(vector<shared_ptr<Edge>> es)
    {
        this->edges = es;
        this->sides = edges.size();
        if (!this->IsValid())
            cout << "Warning,your shape is invalid. " << endl;//构造之后进行合法性判断
    }
    Polygon(const Polygon& p)
    {
        this->edges = p.edges;
        this->sides = edges.size();
    }
    ~Polygon() {} //以上为有无参数的构造函数，复制构造函数和析构函数，无需析构内容故为空
    vector<Point> getpoints(vector<shared_ptr<Edge>> edges, int length) const
    {
        vector<Point> points;
        for (int i = 0; i < length; ++i)
        {
            points.push_back((*edges[i]).getp1());
        }
        return points;
    }//该函数用于获得多边形的所有点，由于首尾相接，故只需全部取第一个点即可
    double Circumference() const  override
    {
        double sum = 0;
        for (int i = 0; i < sides; ++i)
        {
            sum += (*edges[i]).getlen();
        }
        return sum;
    } //周长以所有边调用getlen函数累加得来
    double Area() const  override
    {
        if (!this->IsValid())
            return UnknownValue;
        double area = 0.0;
        int length = sides;
        vector<Point> points;
        points = getpoints(edges, length);
        for (int i = 0; i < length - 1; ++i)
        {
            area += LinearIntegration(points[i], points[i + 1]);
        }
        area += LinearIntegration(points[length - 1], points[0]);
        return area >= 0.0 ? area : -area;
    } //该部分函数参考自网上一种n边形的面积求法，通过有序点数组求得有向面积累加
    void set(vector<shared_ptr<Edge>> es)
    {
        this->edges = es;
        this->sides = edges.size();
    }
    void Print() const  override
    {
        printf("This is a polygon with %d sides\n", sides);
        for (int i = 0; i < sides; ++i)
        {
            cout << i + 1 << ":";
            (*edges[i]).Print();
        }
        cout << "The circumference is: " << Circumference() << ",the area is: " << Area() << endl;
    }//若合法，打印出所有图形信息：边数，所有边的起点和终点，周长，面积
    virtual bool IsValid()const override
    {
        if (sides < 3)
            return false;
        if ((*edges[sides - 1]).getp2() != (*edges[0]).getp1())
            return false;
        for (int i = 0; i < sides - 1; ++i)
        {
            if ((*edges[i]).getp2() != (*edges[i + 1]).getp1())
                return false;
        }
        return true;
    } //多边形按照边数必须大于2，且每一条边的终点跟下一边的起点相接来判断合法与否
    Polygon operator|(const Polygon& p) //判断是否为同一类
    {
        if (typeid(*this) == typeid(p))
        {
            vector<Point> v;
            vector<Point> t1;
            t1 = getpoints(this->edges, this->sides);
            vector<Point> t2;
            t2 = getpoints(p.edges, p.sides);
            for (unsigned i = 0; i < t1.size(); i++)
            {
                v.push_back(t1[i]);
            }
            for (unsigned i = 0; i < t2.size(); i++)
            {
                v.push_back(t2[i]);
            }
            vector<Point> r;
            for (int i = 0; i < 4; i++)
            {
                r.push_back(v[(rand() % (v.size() + 1))]);
            }
            vector<shared_ptr<Edge>> e;
            for (unsigned i = 0; i < r.size() - 1; i++)
            {
                Edge temp(r[i], r[i + 1]);
                shared_ptr<Edge> ptr = make_shared<Edge>(temp);
                e.push_back(ptr);
            }
            Edge temp(r.back(), r[0]);
            shared_ptr<Edge> ptr = make_shared<Edge>(temp);
            e.push_back(ptr);
            Polygon result(e);
            return result;
        }
        Polygon result;
        return result;
    }
    Polygon operator&(const Polygon& p) //判断是否为同一类
    {
        if (typeid(*this) == typeid(p))
        {
            vector<Point> v;
            vector<Point> t1;
            t1 = getpoints(this->edges, this->sides);
            vector<Point> t2;
            t2 = getpoints(p.edges, p.sides);
            for (unsigned i = 0; i < t1.size(); i++)
            {
                v.push_back(t1[i]);
            }
            for (unsigned i = 0; i < t2.size(); i++)
            {
                v.push_back(t2[i]);
            }
            vector<shared_ptr<Edge>> e;
            for (unsigned i = 0; i < v.size() - 1; i++)
            {
                Edge temp(v[i], v[i + 1]);
                shared_ptr<Edge> ptr = make_shared<Edge>(temp);
                e.push_back(ptr);
            }
            Edge temp(v.back(), v[0]);
            shared_ptr<Edge> ptr = make_shared<Edge>(temp);
            e.push_back(ptr);
            Polygon result(e);
            return result;
        }
        Polygon result;
        return result;
    }//由于本次作业不是考察凸包算法等内容，故多边形的交是返回一个现有点中的随机4边形，并是返回所有点组合的n边形
private:
    vector<shared_ptr<Edge>> edges;
    int sides;
};


#endif