## 一. 简答题（共5题）

### 1. (简答题)Problem 1 (15 分)

### Problem 1.1. 请将以下内容写进文件“Companionship of Books.txt”(5 分)“A man may usually be known by the books he reads as well as by the company he keeps. for there is a companionship of books as well as of men. one should always live in the best company, whether it be of books or of men.”

### Problem 1.2. 请计算Problem1.1 中“books”一词出现了多少次。(5 分)

### Problem 1.3. 请用程序检查Problem1.1中第二句话的首字母是否大写，若没有应改为对应的大写字母。(5 分) 

*我的答案：*

```matlab
%1.1

fid = fopen('Companionship of Books.txt ', 'w');     %以'w'方式创建该txt文件

A = "A man may usually be known by the books he reads as well as by the company he keeps. for there is a companionship of books as well as of men. one should always live in the best company, whether it be of books or of men.";

fprintf(fid,'%s',A);                   %以字符串的数据类型写入指定内容

fclose(fid);                       %关闭txt文件，防止出错

%1.2

fid = fopen('Companionship of Books.txt ','r');   %以‘r’：只读方式打开文件（默认方式可省略不写）

B=fscanf(fid,'%c');k=0;                 %将文本以字符的形式（包括空格）读入B中；为k赋初值

for n=1:length(B)                    %通过for循环与多重if语句进行判断

  if B(n)=='b'

​    if B(n+1)=='o'

​      if B(n+2)=='o'

​        if B(n+3)=='k'

​          if B(n+4)=='s'

​            k=k+1;

​          end

​        end

​      end

​    end

  end

end                           %end不能漏，且注意缩进

fclose(fid);                       %关闭txt文件，防止出错

disp('How many times did the word "books" appear')

disp(k);

%1.3

for n=1:length(B)                    %依旧利用for循环遍历B，找到指定位置        

  if B(n)=='.'                     %第二句话的首字母应该在'.'后第二位（后第一位是空格）

​    if B(n+2) >= 'a'&&B(n+2) <= 'z'         %检查目标大写与否

​      B(n+2)=upper(B(n+2));break;         

%使用upper函数将字符串转换为大写;简化第一节课char(abs()-32)的做法

​    end   

%只检查第二句话首字母，故直接使用break跳出循环；若删去可以转换每一句话首字母，但要注意n+2>length

  end

end

fid = fopen('Companionship of Books.txt ', 'w'); 

fprintf(fid,'%s',B);                   %以字符串的数据类型写入指定内容

fclose(fid);                       %关闭txt文件，防止出错

disp(B)
```

![img](https://p.ananas.chaoxing.com/star3/origin/f7b4637782fde1bd09679b7455e4df85.png)![img](https://p.ananas.chaoxing.com/star3/origin/ff64c12b30851faba5ba07ee138beb62.png)

做第一题时感觉自己的代码很冗长累赘，于是在帮助中心搜索“字符串匹配”寻找相关函数，最终发现既可以用regexp(B,'books')输出起始索引，也可以用count(B,'books')直接算出出现次数![img](https://p.ananas.chaoxing.com/star3/origin/a68674c1d7c3fb29686a35d118c567e9.png)

### 2. (简答题)Problem 2 (15 分)

### Problem 2.1. 请读取并在matlab中载入文件“Assignment2_materials.xlsx”表单1的数据，并保持现有数据在一个元胞数组中。(5 分)

### Problem 2.2. 将以上数据转存到在一个结构体中。(5 分)

### Problem 2.3. 计算出每一门课所有同学的平均成绩，并从高到低排列。(5 分)

*我的答案：*

```matlab
%2.1

cell = readcell('Assignment2_materials.xlsx');  %通过阅读help文档发现xlsread并不被推荐使用，通过readcell直接读取元胞数组cell

%2.2

fields = readcell('Assignment2_materials.xlsx','Range','A1:E1');  

%通过Range读取特定行列数据 使最终的struct符合要求

cell2 = readcell('Assignment2_materials.xlsx','Range','A2:E5');  

struct = cell2struct(cell2,fields,2);            

%元胞数组转结构体，使用cell to struct,了解用法之后补充参数fields和dim

%2.3

grade = xlsread('Assignment2_materials.xlsx','C2:E5');   %直接读取成绩相关数据

mean(grade)                         %计算三门课的平均成绩

sort(ans,'descend')                     %题目要求降序，补充参数'descend'
```

![img](https://p.ananas.chaoxing.com/star3/origin/727659a73e83ec22c3bcab802991f741.png)![img](https://p.ananas.chaoxing.com/star3/origin/aaec4408b3ec47b0c8ad709199f14341.png)![img](https://p.ananas.chaoxing.com/star3/origin/10945a5d583a504c5de0bb5b83e5f1ff.png)

2.1中readtable、readmatrix 或 readcell等函数读取数据更具有针对性，应该从中选用

2.2中为了不出现以下效果，必须分开读取数据![img](https://p.ananas.chaoxing.com/star3/origin/0fd648e73666d401a32183cc2aa1d9b0.png)

### 3. (简答题)Problem 3 (15 分)

### 读取文件“Assignment2_student_namelist.xlsx”中每位同学的人名，并完成一个随机点到程序，要求：

### （1）每次随机挑出10名同学，并写如一个txt文件的一行。下一次随机抽查的10位同学姓名写在下一行；

### （2）点过名的同学还有机会被再次点到；

### （3）请画图证明在20次抽查后，每位同学至少被抽查2次。

*我的答案：*

```matlab
%3

fid = fopen('Lucky guys.txt ', 'a');  %创建txt文件，且必须以‘a’方式，确保追加数据到文件末尾

name = readcell('Assignment2_student_namelist.xlsx');  %读取名单到元胞数组中，共98位

A = randperm(98);                 

%生成1~98的无序数组

B=char(name(A(1:10)));           

%取前10位，并用char函数转换

fprintf(fid,'%s\r\n',B');          

%打印到txt文件中，且要换行
```

![img](https://p.ananas.chaoxing.com/star3/origin/69d5aae97d496df9704157be2b148535.png)

每运行一次A都是1~98无序的98个数，故前10个数不重复且可能点到2次

```matlab
A = randperm(98);B = A(1:10);

for n=1:19

  A = randperm(98);                

  B = [B A(1:10)];

end

histogram(B,'BinWidth',1)
```

绘制了多幅直方图，该条件下无法确保每位同学至少被抽查2次

![img](https://p.ananas.chaoxing.com/star3/origin/aeac8da7257f8e02499439c4521f568e.png)

因此必须记录每一次抽查数据，在同一个数被抽到2次之后就剔除

确保每位同学可重复抽查，且至少为2次。

![img](https://p.ananas.chaoxing.com/star3/origin/1f1582ba574aba8a56cc044f28177cf1.png)

后来我尝试着用matlab的GUI编写一个抽签的程序，不过还在探索，非常简陋

### 4. (简答题)Problem 4 (30 分)

### Problem 4.1. 画出如下图所示的椭圆![img](https://p.ananas.chaoxing.com/star3/origin/9c377b30c0478523bd5b164b83fee57e.png)（5 分） ![img](https://p.ananas.chaoxing.com/star3/origin/cbbb6d4140bcb0829a57db0e3fd4de4d.png) 

### Problem 4.2. 请根据文件“Assignment2_materials.xlsx”中表单2“2019届毕业生情况表”的内容，画出所有可反应该信息的2D图（至少3种）。（15 分）

### Problem 4.3. 对比Problem 4.2中所画出的所有图，分析和对比他们的不同以及优劣点。（10 分）

*我的答案：*

```matlab
%4.1

a = 4;b = 3;       %给椭圆的长半轴短半轴赋值

theta=0:pi/100:2*pi;   %以pi/100为圆心角画椭圆

x=a*cos(theta);       %通过椭圆的参数方程得出变量x和y

y=b*sin(theta);       

plot(x,y,'m');         %画出椭圆，并且选定颜色为品红

title('椭圆x²/16+y²/9=1');    %输入标题，且通过输入法软键盘输出‘²’
```



![img](https://p.ananas.chaoxing.com/star3/origin/da7b4da72cb53deb2a01a07ec35e8528.png)



```matlab
%4.2

A = readcell('Assignment2_materials.xlsx','Sheet',2,'Range','A2:C37'); %读取班级，性别和成绩数据

i=1;k=1;a=1;b=1;M1=zeros;F1=zeros;M2=zeros;F2=zeros;         %为接下来需要使用的变量赋初值

for n=1:length(A)            %循环length（A）次即可，元胞数组前半部分判断，后半部分赋值

  if cell2mat(A(n))==1         %通过if条件的嵌套，将成绩分为四组1班/2班的男生/女生

​    if char(A(n+length(A)))=='男'

​      M1(i)=cell2mat(A(length(A)*2+n));i=i+1;

​    else

​      F1(k)=cell2mat(A(length(A)*2+n));k=k+1;

​    end

  else

​    if char(A(n+length(A)))=='男'

​      M2(a)=cell2mat(A(length(A)*2+n));a=a+1;

​    else

​      F2(b)=cell2mat(A(length(A)*2+n));b=b+1;

​    end

  end

end



%二维线图/散点图

t = tiledlayout(4,2);

ax1 = nexttile;

ax2 = nexttile;

ax3 = nexttile;

ax4 = nexttile;

ax5 = nexttile;

ax6 = nexttile;

ax7 = nexttile;

ax8 = nexttile;

plot(ax1,F1,'r')

scatter(ax2,F1,1:length(F1),'r','filled')

hold([ax1 ax2],'on')

plot(ax3,M1,'b')

scatter(ax4,M1,1:length(M1),'b','filled')

hold([ax3 ax4],'on')

plot(ax5,F2,'m')

scatter(ax6,F2,1:length(F2),'m')

hold([ax5 ax6],'on')

plot(ax7,M2,'y')

scatter(ax8,M2,1:length(M2),'y')
```

![img](https://p.ananas.chaoxing.com/star3/origin/c8bc1fd232077b3a78f72947fade764e.png)

```matlab
%条形图

t = tiledlayout(2,2);

ax1 = nexttile;

ax2 = nexttile;

ax3 = nexttile;

ax4 = nexttile;

bar(ax1,F1,'r')

bar(ax2,M1,'b')

bar(ax3,F2,'m')

bar(ax4,M2,'y')
```

![img](https://p.ananas.chaoxing.com/star3/origin/e17e815ccf8cd174a664ab6d58bf12a5.png)

```matlab
%阶梯图

t = tiledlayout(2,2);

ax1 = nexttile;

ax2 = nexttile;

ax3 = nexttile;

ax4 = nexttile;

stairs(ax1,F1,'r')

stairs(ax2,M1,'b')

stairs(ax3,F2,'m')

stairs(ax4,M2,'y')
```

![img](https://p.ananas.chaoxing.com/star3/origin/9ef7e15586abbd2f14511653f48f3fbd.png)

```matlab
%饼图

t = tiledlayout(1,2);

ax1 = nexttile;

ax2 = nexttile;

pie(ax1,sort([F1 M1 F2 M2]))      %成绩升序饼图

label={'1班女生','1班男生','2班女生','2班男生'};

pie(ax2,[length(F1) length(M1) length(F2) length(M2)],label) %男女人数饼图
```

![img](https://p.ananas.chaoxing.com/star3/origin/239264856324c5f7d81a7b5c23e636bc.png)

%4.3

4.2中我作出了5种2D图像，它们都让成绩数据更加直观。

二维线图/散点图/条形图/阶梯图都可以通过y轴观察出学生的成绩水平，二维线图和散点图的对比可以看出各个分数段学生的分布；条形图和阶梯图较为类似，可看出成绩的极差。而与前几种差异较大的饼图虽然不能直接看出成绩高低，但可以展现出各个分数和人数占总体的比例。

在第二小题中，我设法将男女同学的成绩分别读出，希望以此作出各种直观的2D图像；但由于四个向量的长度不同，我想画出的叠加条形图，气泡图等都没有成功，已作图像也不甚理想。尝试补0却使图像突变，暂未得出较好的解决方法。如果能画到一张图上，并且补充图例说明，信息的反映应该更好。

### 5. (简答题)Problem 5 (25 分)

### Problem 5.1. 绘制图形![img](https://p.ananas.chaoxing.com/star3/origin/293f75dfb3714d81f3076b955bfb6995.png)分析当参数a，b，c，d取不同值时对图形的影响（同学们可以取n组不用的a，b，c，d值，并绘制n张图进行讨论。），n的取值同学可以自己决定，合理即可（15 分） 

### Problem 5.2. 在xy平面内选择区间[-8, 8] x [-8,8], 利用mesh，meshc，meshz和surf绘制![img](https://p.ananas.chaoxing.com/star3/origin/2c420f99726146e9242beb989fcc53b4.png)要求用子图在一个图形窗口中绘制。（10 分）

*我的答案：*

```matlab
%5.1

[x,y,z] = meshgrid( linspace( -10, 10, 100 ) );

a = randi([-10 10]);

b = randi([-10 10]);

c = randi([-10 10]);

d = randi([-10 10]);

f = x.^2/a^2 + y.^2/b^2 + z.^2/c^2 ;

isosurface(x, y, z, f, d);
```

a/b/c/d的值均使用-10~10的随机数，n次运行中部分结果如下：

![img](https://p.ananas.chaoxing.com/star3/origin/5d252c2cdc9633cb652d16963601a111.png)

![img](https://p.ananas.chaoxing.com/star3/origin/db61765f78ce1847fd80ed9639002a0f.png)![img](https://p.ananas.chaoxing.com/star3/origin/f3b5716adb1627443f9d336df386f2e8.png)![img](https://p.ananas.chaoxing.com/star3/origin/af5c13741722deb58c3eaf52d4d24262.png)

n次实验中大部分都无法画出图像来，结合高数知识可得：

![img](https://p.ananas.chaoxing.com/star3/origin/3242d426d5af76cf2463d4fe12602c8f.png)

```matlab
%5.2

[X,Y] = meshgrid(-8:.5:8);    %选择区间[-8, 8] x [-8,8]

R = sqrt(X.^2 + Y.^2) + eps;

Z = sin(R)./R;        %通过变量R来获得符合条件的Z

t = tiledlayout(2,2);    %创建分块图布局，用于显示所绘制的4张图

ax1 = nexttile;

ax2 = nexttile;

ax3 = nexttile;

ax4 = nexttile;

%创建三个相同大小的矩阵。然后将它们绘制为一个网格图。该绘图使用 Z 确定高度和颜色。

mesh(ax1,X,Y,Z)

%创建三个相同大小的矩阵。然后将它们绘制为一个网格图，其下方有一个等高线图。网格图使用 Z 确定高度和颜色。

meshc(ax2,X,Y,Z)

%创建三个相同大小的矩阵。然后将它们绘制为带帷幕的网格图。网格图使用 Z 确定高度和颜色。

meshz(ax3,X,Y,Z)

%创建三个相同大小的矩阵。然后将它们绘制为一个曲面。曲面图对高度和颜色均使用 Z。

surf(ax4,X,Y,Z)
```

![img](https://p.ananas.chaoxing.com/star3/origin/9c101027c93cda952fb93c8333adf702.png)

在完成5.2的过程中，我在matlab的help文档搜索mesh，准备阅读其用法及括号内所需参数，巧合的是示例中第一个即为题目要求的Z。但是与我预想的不同的是，示例在sqrt(X.^2 + Y.^2)后多加了eps，但删去又貌似不影响结果。回忆第一节课内容eps=2.2204e-16，我本以为这只是一个类似于pi的极小数，阅读相关资料才发现：eps表示浮点相对精度，对双精度数值来说eps表示从 1.0 到下一个最大双精度数的距离。对单精度数值来说eps表示从 1.0 到下一个最大单精度数的距离。在此处可以起到防止分母为零的作用。