#include"Person.h"
Person::Person()
{
    this->id_ = '\0';
    this->name_ = '\0';
}
Person::Person(std::string id, std::string name) : id_(id), name_(name) {} //初始化列表
Person::Person(const Person& p)
{
    this->id_ = p.id_;
    this->name_ = p.name_;
}
void Person::display()
{
    std::cout << name_ << ",ID : " << id_ << std::endl;
}
std::ostream& operator<<(std::ostream& out, const Person& P)
{
    out << P.name_ << ",ID : " << P.id_ << std::endl;
    return out;
}
Student::Student()
{
    this->schoolName_ = '\0';
    this->discount_ = -1;
    this->id_ = '\0';
    this->name_ = '\0';
}
Student::Student(std::string id, std::string name, std::string schoolName) :
    schoolName_(schoolName)
{
    this->id_ = id;
    this->name_ = name;
}
Student::Student(const Student& s)
{
    this->id_ = s.id_;
    this->name_ = s.name_;
    this->schoolName_ = s.schoolName_;
    this->discount_ = s.discount_;
}
void Student::display()
{
    std::cout << name_ << ",ID : " << id_ << ", from " << schoolName_ << std::endl;
}
std::ostream& operator<<(std::ostream& out, const Student& P)
{
    out << P.name_ << ",ID : " << P.id_ << ", from " << P.schoolName_ << std::endl;
    return out;
}//输出流重载与display较为类似，但不能遗漏return