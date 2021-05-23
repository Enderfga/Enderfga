//从左到右的数据为：周目、第几节课、科目ID、科目名字、其他信息。
//如在周五第三节课有一节课为篮球课，编号是cxk，在舞蹈房上课，则是l("5","3","cxk","篮球课","舞蹈房"");
l("1","1","a","数据结构与算法","金老师");
l("1","3","a","博弈论","李老师");
l("2","1","b","概率统计","朱老师");
l("3","2","b","C++程序设计","谭老师");
l("3","1","c","高等代数","李老师");
l("4","3","c","无机化学","金老师");
l("1","2","d","数学分析","李老师");
l("5","4","e","思想道德修养与法律基础","陈老师");
l("5","3","f","书法","姚老师");

function l(c,t,n,clsname,intext){
	var id="info"+c+t,clsid="info "+n;var elm=document.getElementById(id);if (t=="1"){var time="08:00-09:50 ";} else if (t=="2"){var time="10:00-11:40 ";} else if (t=="3"){var time="14:30-16:05 ";} else if (t=="4"){var time="16:15-17:50 ";} else if (t=="5"){var time="18:00~ ";}  else {var time="~ ";};
	elm.innerHTML=time+"<div class='intext'>"+clsname+"</div>"+"<div class='intext'>"+intext+"</div>";
	elm.className=clsid;elm.style.color="#fff";elm.style.display="block"
};
