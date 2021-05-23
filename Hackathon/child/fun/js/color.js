function getCookie(cname) {var name = cname + "=";var ca = document.cookie.split(';');for(var i = 0; i < ca.length; i++) {var c = ca[i];while (c.charAt(0) == ' ') {c = c.substring(1);}if (c.indexOf(name)  == 0) {return c.substring(name.length, c.length);}}return "";
};var style=getCookie("style");console.log(style);function setstyle() {if (style==1){setstyle1();} else if (style==2){setstyle2();} else {setstyle0();};};

var mq="3"/*菜单列表数量+1*/,cq="3"/*科目数量+1*/;

function setstyle0(){
	var manuid="0";
		for (var i=0;i<mq;i++){var x="mc"+i;document.getElementById(x).className="ml";};var menuid="mc"+manuid;document.getElementById(menuid).className="ml active";
		var c="info";var x=document.getElementsByClassName(c);
		for (var i=0;i<x.length;i++){
			x[i].style.background="badcolor";x[i].style.color="badcolor";
		};document.cookie="style=0";
};

function setstyle1(){
	var manuid="1";
		for (var i=0;i<mq;i++){var x="mc"+i;document.getElementById(x).className="ml";};var menuid="mc"+manuid;document.getElementById(menuid).className="ml active";
		var c="info";var x=document.getElementsByClassName(c);
		for (var i=0;i<x.length;i++){
			x[i].style.background="#fff";x[i].style.color="#000";
		};
	document.cookie="style=1";
};

function setstyle2(){
	var manuid="2";document.cookie="style=2";
		for (var i=0;i<mq;i++){var x="mc"+i;document.getElementById(x).className="ml";};var menuid="mc"+manuid;document.getElementById(menuid).className="ml active";
		var c="info";var x=document.getElementsByClassName(c);
		for (var i=0;i<x.length;i++){
			x[i].style.background="#000";x[i].style.color="#fff";
		};document.cookie="style=2";
};
