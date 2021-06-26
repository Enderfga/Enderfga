#include"Activity.h"
Date::Date() :year_(0), month_(0), day_(0) {}
Date::Date(int year, int month, int day):year_(year),month_(month),day_(day){}
Date::Date(const Date& d){
	this->year_ = d.year_;
	this->month_ = d.month_;
	this->day_ = d.day_;
}//定义与声明分离，每一个类都写好有无参数的构造函数和复制构造函数
Date& Date::operator=(const Date& d) {
	this->year_ = d.year_;
	this->month_ = d.month_;
	this->day_ = d.day_;
	return *this;
}
std::ostream& operator<<(std::ostream& u,const Date& d)
{
	u << d.year_ << '.' << d.month_ << '.' << d.day_;
	return u;
}
Activity::Activity() {
	this->place_ = '\0';
	this->activity_ = '\0';
	Date tmp1;
	this->date_ = tmp1;
	std::set<std::shared_ptr<Person>> tmp2;
	this->members_ = tmp2;
}
Activity::Activity(Date date, std::string place, std::string activity, std::set<std::shared_ptr<Person>> members):
	date_(date),place_(place),activity_(activity),members_(members) {}
Activity::Activity(const Activity& a) {
	this->date_ = a.date_;
	this->place_ = a.place_;
	this->activity_ = a.activity_;
	this->members_ = a.members_;
}//定义与声明分离，每一个类都写好有无参数的构造函数和复制构造函数
void Activity::print() const {
	std::cout << activity_ << ":" << std::endl;
	std::cout << date_<< " 举办于" << place_ << std::endl;
	std::cout << "成员: " << std::endl;//为了简化变量初始化，本次作业中的iterator应该使用auto替代更好，在下一题中改进
	for (std::set<std::shared_ptr<Person>>::iterator it = members_.begin(); it != members_.end(); it++)
	{
		(*it)->display();
	}
}