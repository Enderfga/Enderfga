#include"Club.h"
using namespace std;//为防止扩大化命名空间冲突，只在main.cpp里使用
int main() {
/*手工建立4个Club对象，
两个SportsClub，两个MusicClub，
各包含1个Person和2个Student对象，
加入到ClubCenter对象当中。*/
	set<shared_ptr<Person>> set1, set2, set3, set4;
	Person p1("4001", "Pelham");
	shared_ptr<Person> ptr1 = make_shared<Person>(p1);
	set1.insert(ptr1);
	Person p2("4002", "Ingram");
	shared_ptr<Person> ptr2 = make_shared<Person>(p2);
	set2.insert(ptr2);
	Person p3("4003", "Alden");
	shared_ptr<Person> ptr3 = make_shared<Person>(p3);
	set3.insert(ptr3);
	Person p4("4004", "Tammy");
	shared_ptr<Person> ptr4 = make_shared<Person>(p4);
	set4.insert(ptr4);
	Student s1("4005", "Barbara","SYSU");
	shared_ptr<Student> ptr5 = make_shared<Student>(s1);
	set1.insert(ptr5);
	Student s2("4006", "Vanida", "SYSU");
	shared_ptr<Student> ptr6 = make_shared<Student>(s2);
	set1.insert(ptr6);
	Student s3("4007", "Bartola", "SYSU");
	shared_ptr<Student> ptr7 = make_shared<Student>(s3);
	set2.insert(ptr7);
	Student s4("4008", "Brielle", "SYSU");
	shared_ptr<Student> ptr8 = make_shared<Student>(s4);
	set2.insert(ptr8);
	Student s5("4009", "Garner", "SYSU");
	shared_ptr<Student> ptr9 = make_shared<Student>(s5);
	set3.insert(ptr9);
	Student s6("4010", "Franklyn", "SYSU");
	shared_ptr<Student> ptr10 = make_shared<Student>(s6);
	set3.insert(ptr10);
	Student s7("4011", "Celestyn", "SYSU");
	shared_ptr<Student> ptr11 = make_shared<Student>(s7);
	set4.insert(ptr11);
	Student s8("4012", "Gregg", "SYSU");
	shared_ptr<Student> ptr12 = make_shared<Student>(s8);
	set4.insert(ptr12);
	/*构造好全部12个成员之后，开始构造活动与俱乐部中心*/
	set<shared_ptr<Activity>> set5, set6, set7, set8;
	Date date(2021, 6, 22);
	Activity a1(date, "西园排球场", "排球赛", set1);
	shared_ptr<Activity> ptr13 = make_shared<Activity>(a1);
	set5.insert(ptr13);
	Activity a2(date, "西园篮球场", "篮球赛", set2);
	shared_ptr<Activity> ptr14 = make_shared<Activity>(a2);
	set6.insert(ptr14);
	Activity a3(date, "西二101", "合唱表演", set3);
	shared_ptr<Activity> ptr15 = make_shared<Activity>(a3);
	set7.insert(ptr15);
	Activity a4(date, "西三204", "音乐剧", set4);
	shared_ptr<Activity> ptr16 = make_shared<Activity>(a4);
	set8.insert(ptr16);
	ClubCenter clubcenter;
	SportsClub sc1("排球俱乐部", set1, set5, "王老师");
	sc1.used = (SportsClub::interest_)3;//即为排球
	shared_ptr<SportsClub> ptr17 = make_shared<SportsClub>(sc1);
	clubcenter.addClub(ptr17);
	SportsClub sc2("篮球俱乐部", set2, set6, "李老师");
	sc2.used = (SportsClub::interest_)2;//即为篮球
	shared_ptr<SportsClub> ptr18 = make_shared<SportsClub>(sc2);
	clubcenter.addClub(ptr18);
	MusicClub mc1("合唱团", set3, set7, "方老师");
	mc1.used = (MusicClub::instrument_)2;//即为歌曲
	shared_ptr<MusicClub> ptr19 = make_shared<MusicClub>(mc1);
	clubcenter.addClub(ptr19);
	MusicClub mc2("话剧社", set4, set8, "赵老师");
	mc2.used = (MusicClub::instrument_)0;//即为钢琴
	shared_ptr<MusicClub> ptr20 = make_shared<MusicClub>(mc2);
	clubcenter.addClub(ptr20);
	clubcenter.displayClub();//展示以上所有信息
}