%4.2
A = readcell('Assignment2_materials.xlsx','Sheet',2,'Range','A2:C37'); %读取班级，性别和成绩数据
i=1;k=1;a=1;b=1;M1=zeros;F1=zeros;M2=zeros;F2=zeros;                       %为接下来需要使用的变量赋初值
for n=1:length(A)                        %循环length（A）次即可，元胞数组前半部分判断，后半部分赋值
    if cell2mat(A(n))==1                 %通过if条件的嵌套，将成绩分为四组1班/2班的男生/女生
        if char(A(n+length(A)))=='男'
            M1(i)=cell2mat(A(length(A)*2+n));i=i+1;
        else
            F1(k)=cell2mat(A(length(A)*2+n));k=k+1;
        end
    else
        if char(A(n+length(A)))=='男'
            M2(a)=cell2mat(A(length(A)*2+n));a=a+1;
        else
            F2(b)=cell2mat(A(length(A)*2+n));b=b+1;
        end
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
%饼图
t = tiledlayout(1,2);
ax1 = nexttile;
ax2 = nexttile;
pie(ax1,sort([F1 M1 F2 M2]))            %成绩升序饼图
label={'1班女生','1班男生','2班女生','2班男生'};
pie(ax2,[length(F1) length(M1) length(F2) length(M2)],label) %男女人数饼图

