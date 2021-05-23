//从左到右的数据为：周目、第几节课、科目ID、科目名字、其他信息。
//如在周五第三节课有一节课为篮球课，编号是cxk，在舞蹈房上课，则是l("5","3","cxk","篮球课","舞蹈房"");
l("1","1","a","奶茶店","饮冰室");
l("1","2","a","打印店","文字新生");
l("2","1","b","棋牌室","来局昆特牌？");
l("3","4","b","酒吧","来生");
l("3","1","c","小卖铺","猪婆山");
l("3","2","c","打印店","千纸鹤");
l("4","2","d","美妆店","小杰的百宝箱");
l("5","2","e","烘焙店","章鱼小丸子");
l("1","4","f","电脑店","修电脑的");

function l(c,t,n,clsname,intext){
	var id="info"+c+t,clsid="info "+n;var elm=document.getElementById(id);if (t=="1"){var time="714 ";} else if (t=="2"){var time="1012 ";} else if (t=="3"){var time="1206 ";} else if (t=="4"){var time="1514 ";} else if (t=="5"){var time="2019 ";}  else {var time="~ ";};
	elm.innerHTML=time+"<div class='intext'>"+clsname+"</div>"+"<div class='intext'>"+intext+"</div>";
	elm.className=clsid;elm.style.color="#fff";elm.style.display="block"
};
