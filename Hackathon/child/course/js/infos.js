//从左到右的数据为：周目、第几节课、科目ID、科目名字、其他信息。
//如在周五第三节课有一节课为篮球课，编号是cxk，在舞蹈房上课，则是l("5","3","cxk","篮球课","舞蹈房"");
l("1","1","a","高等数学","李老师");
l("1","2","a","大学物理","刘老师");
l("2","1","b","C程序设计","高老师");
l("3","4","b","C++程序设计","谭老师");
l("3","1","c","Python程序设计","金老师");
l("3","2","c","Matlab程序设计","金老师");
l("4","2","d","学术英语","王老师");
l("5","2","e","思想道德修养与法律基础","陈老师");
l("1","4","f","形势与政策","张老师（单周）");

function l(c,t,n,clsname,intext){
	var id="info"+c+t,clsid="info "+n;var elm=document.getElementById(id);if (t=="1"){var time="08:00-09:50 ";} else if (t=="2"){var time="10:00-11:40 ";} else if (t=="3"){var time="14:30-16:05 ";} else if (t=="4"){var time="16:15-17:50 ";} else if (t=="5"){var time="18:00~ ";}  else {var time="~ ";};
	elm.innerHTML=time+"<div class='intext'>"+clsname+"</div>"+"<div class='intext'>"+intext+"</div>";
	elm.className=clsid;elm.style.color="#fff";elm.style.display="block"
};
