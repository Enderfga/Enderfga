#pragma once
#include"Person.h"
#include<set>
class Date
{
public:
	Date();
	Date(int year, int month, int day);
	Date(const Date& d);
	~Date(){}
	Date& operator=(const Date&);//内容与复制构造函数较为类似，重载之后便于比较
	friend std::ostream& operator << (std::ostream& u,const Date& d);//输出流重载，方便按格式打印时间
private:
	int year_;
	int month_;
	int day_;
};
class Activity//不需要继承Date，将date作为成员变量
{
public:
	Activity();
	Activity(Date date, std::string place, std::string activity, std::set<std::shared_ptr<Person>> members);
	Activity(const Activity& a);
	~Activity(){}
	void print() const;
private:
	Date date_;
	std::string place_;
	std::string activity_;
	std::set<std::shared_ptr<Person>> members_;
};