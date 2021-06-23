#pragma once
#include"Activity.h"
#include<vector>
class Club
{//抽象类，只有纯虚函数，借助其指针实现多态效果
public:
	Club(){}
	~Club(){}
	virtual void displayMembers() const = 0;
	virtual void displayActivities() const = 0;
	virtual void addMember(const Person&) = 0;
	virtual void addActivity(const Activity&) = 0;
protected://基类用protected而不是private，子类可以访问
	std::string name_;
	std::set<std::shared_ptr<Person>> members_;
	std::set<std::shared_ptr<Activity>> activity_;
};
class SportsClub:public Club
{
public:
	SportsClub();
	SportsClub(std::string name,std::set<std::shared_ptr<Person>> members,std::set<std::shared_ptr<Activity>> activity, std::string coach);
	SportsClub(const SportsClub& sc);
	~SportsClub(){}
	void displayMembers() const;
	void displayActivities() const;
	void addMember(const Person& p);
	void addActivity(const Activity& a);
private:
	enum interest_ { Running, Swimming };//枚举变量
	std::string coach_;
};
class MusicClub :public Club
{
public:
	MusicClub();
	MusicClub(std::string name, std::set<std::shared_ptr<Person>> members, std::set<std::shared_ptr<Activity>> activity, std::string musician);
	MusicClub(const MusicClub& mc);
	~MusicClub() {}
	void displayMembers() const;
	void displayActivities() const;
	void addMember(const Person& p);
	void addActivity(const Activity& a);
private:
	enum instrument_ { Piano, Violine };//枚举变量
	std::string musician_;
};
class ClubCenter
{
public:
	ClubCenter();
	ClubCenter(std::vector<std::shared_ptr<Club>> clubs);
	ClubCenter(const ClubCenter &cc);
	~ClubCenter(){}
	void displayClub();
	void addClub(std::shared_ptr<Club> c);//直接以Club的智能指针作为参数
private:
	std::vector<std::shared_ptr<Club>> clubs_;
};