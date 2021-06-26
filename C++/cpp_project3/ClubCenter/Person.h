#pragma once//避免同一个头文件被包含(include)多次
#include<iostream>
#include<string>
#include<memory>//使用智能指针管理内存
class Person
{
public:
	Person();
	Person(std::string id, std::string name);
	Person(const Person& p);
	~Person(){}
	virtual void display();//虚函数
protected:
	std::string id_;
	std::string name_;
};
class Student:public Person
{
public:
	Student();
	Student(std::string id, std::string name, std::string schoolName);
	Student(const Student& s);
	~Student(){}
	void display() override;//重写，允许用基类的指针来调用子类的这个函数
private:
	std::string schoolName_;
	double discount_=0;//不明确其含义，后续没有使用
};
