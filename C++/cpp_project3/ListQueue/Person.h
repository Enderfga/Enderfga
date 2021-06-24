#pragma once
#include<iostream>
#include<string>
#include<memory>//使用智能指针管理内存
class Person
{
public:
    Person();
    Person(std::string id, std::string name);
    Person(const Person& p);
    ~Person() {}
    virtual void display();//虚函数
    friend std::ostream& operator<<(std::ostream& out, const Person& P);
protected:
    std::string id_;
    std::string name_;
};
class Student : public Person
{
public:
    Student();
    Student(std::string id, std::string name, std::string schoolName);
    Student(const Student& s);
    ~Student() {}
    void display();//重写，允许用基类的指针来调用子类的这个函数
    friend std::ostream& operator<<(std::ostream& out, const Student& P);
    //输出流重载，使MyVecter<Student>可以输出
private:
    std::string schoolName_;
    double discount_ = 0; //不明确其含义，后续没有使用
};
