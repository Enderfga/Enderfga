#include"Person.h"
Person::Person(){this->id_ = '\0';this->name_ = '\0';}
Person::Person(std::string id, std::string name):id_(id),name_(name) {}//初始化列表
Person::Person(const Person& p) {
	this->id_ = p.id_;
	this->name_ = p.name_;
}//定义与声明分离，每一个类都写好有无参数的构造函数和复制构造函数
void Person::display() {
	std::cout << name_ << "，号码： " << id_ << std::endl;
}
Student::Student(){
	this->schoolName_ = '\0';
	this->discount_ = -1;
	this->id_ = '\0'; 
	this->name_ = '\0';
}
Student::Student(std::string id, std::string name, std::string schoolName):
schoolName_(schoolName){
	this->id_ = id;
	this->name_ = name;
}
Student::Student(const Student& s) {
	this->id_ = s.id_;
	this->name_ = s.name_;
	this->schoolName_ = s.schoolName_;
	this->discount_ = s.discount_;
}
void Student::display() {
	std::cout << name_ << "，来自" << schoolName_ << "，学号：" << id_ << std::endl;
}