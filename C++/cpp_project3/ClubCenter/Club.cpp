#include"Club.h"
SportsClub::SportsClub() {
	this->name_ = '\0';
	this->coach_ = '\0';
	std::set<std::shared_ptr<Person>> tmp1;
	this->members_ = tmp1;
	std::set<std::shared_ptr<Activity>> tmp2;
	this->activity_ = tmp2;
}
SportsClub::SportsClub(std::string name, std::set<std::shared_ptr<Person>> members, std::set<std::shared_ptr<Activity>> activity, std::string coach) :coach_(coach) {
	this->name_ = name;
	this->members_ = members;
	this->activity_ = activity;
}
SportsClub::SportsClub(const SportsClub& sc){
	this->name_ = sc.name_;
	this->members_ = sc.members_;
	this->activity_ = sc.activity_;
	this->coach_ = sc.coach_;
}//定义与声明分离，每一个类都写好有无参数的构造函数和复制构造函数
void SportsClub::displayMembers() const {//利用iterator遍历并调用各个函数
	for (std::set<std::shared_ptr<Person>>::iterator it = members_.begin(); it != members_.end(); it++)
	{
		(*it)->display();
	}
}
void SportsClub::displayActivities() const {
	for (std::set<std::shared_ptr<Activity>>::iterator it = activity_.begin(); it != activity_.end(); it++)
	{
		(*it)->print();
	}
	std::cout << "主办部门：" << name_ << ",负责人：" << coach_ << std::endl;
}
void SportsClub::addMember(const Person& p) {
	std::shared_ptr<Person> ptr = std::make_shared<Person>(p);
	members_.insert(ptr);
}
void SportsClub::addActivity(const Activity& a) {
	std::shared_ptr<Activity> ptr = std::make_shared<Activity>(a);
	activity_.insert(ptr);
}

MusicClub::MusicClub() {
	this->musician_ = '\0';
	this->name_ = '\0';
	std::set<std::shared_ptr<Person>> tmp1;
	this->members_ = tmp1;
	std::set<std::shared_ptr<Activity>> tmp2;
	this->activity_ = tmp2;
}
MusicClub::MusicClub(std::string name, std::set<std::shared_ptr<Person>> members, std::set<std::shared_ptr<Activity>> activity, std::string musician) :musician_(musician) {
	this->name_ = name;
	this->members_ = members;
	this->activity_ = activity;
}
MusicClub::MusicClub(const MusicClub& mc) {
	this->name_ = mc.name_;
	this->members_ = mc.members_;
	this->activity_ = mc.activity_;
	this->musician_ = mc.musician_;
}//定义与声明分离，每一个类都写好有无参数的构造函数和复制构造函数
void MusicClub::displayMembers() const {
	for (std::set<std::shared_ptr<Person>>::iterator it = members_.begin(); it != members_.end(); it++)
	{
		(*it)->display();
	}
}
void MusicClub::displayActivities() const {
	for (std::set<std::shared_ptr<Activity>>::iterator it = activity_.begin(); it != activity_.end(); it++)
	{
		(*it)->print();
	}
	std::cout << "主办部门："<<name_<<",负责人：" << musician_ << std::endl;
}
void MusicClub::addMember(const Person& p) {
	std::shared_ptr<Person> ptr = std::make_shared<Person>(p);
	members_.insert(ptr);
}
void MusicClub::addActivity(const Activity& a) {
	std::shared_ptr<Activity> ptr = std::make_shared<Activity>(a);
	activity_.insert(ptr);
}
ClubCenter::ClubCenter(){
	std::vector<std::shared_ptr<Club>> temp;
	this->clubs_ = temp;
}//定义与声明分离，每一个类都写好有无参数的构造函数和复制构造函数
ClubCenter::ClubCenter(std::vector<std::shared_ptr<Club>> clubs):clubs_(clubs){}
ClubCenter::ClubCenter(const ClubCenter& cc) { this->clubs_ = cc.clubs_; }
void ClubCenter::displayClub(){
	for (std::vector<std::shared_ptr<Club>>::iterator it = clubs_.begin(); it != clubs_.end(); it++)
	{
		(*it)->displayActivities();
		//(*it)->displayMembers();  Activity的display函数会展示成员信息，故不需要再调用
		std::cout<<std::endl;
	}
}
void ClubCenter::addClub(std::shared_ptr<Club> c){
	clubs_.push_back(c);
}