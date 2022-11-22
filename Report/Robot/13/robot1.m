clc;clear;
% u = [0,0,0,0,0,10,10,10,10]; %向前行驶0.475m
% curr = [0,0,0,0,0,0,0,0,0,0,0,0];
% vec = [curr,0];
% speed = 0; %无速度控制
% for i=0:0.01:1
%     if i == 0
%         next = NextState(curr,u,0.01,speed);
%         vec = [vec;next,0];
%     else
%         next = NextState(next,u,0.01,speed);
%         vec = [vec;next,0];
%     end
% end
% u = [0,0,0,0,0,-10,10,-10,10]; %向左行驶0.475m
% for i=0:0.01:1
%         next = NextState(next,u,0.01,speed);
%         vec = [vec;next,0];
% end
% u = [0,0,0,0,0,-10,10,10,-10]; %沿着z轴旋转1.234弧度
% for i=0:0.01:1
%         next = NextState(next,u,0.01,speed);
%         vec = [vec;next,0];
% end
% speed = 5;  %速度控制
% u = [0,0,0,0,0,10,10,10,10];
% for i=0:0.01:1
%         next = NextState(next,u,0.01,speed);
%         vec = [vec;next,0];
% end
% u = [0,0,0,0,0,-10,10,-10,10];
% for i=0:0.01:1
%         next = NextState(next,u,0.01,speed);
%         vec = [vec;next,0];
% end
% u = [0,0,0,0,0,-10,10,10,-10];
% for i=0:0.01:1
%         next = NextState(next,u,0.01,speed);
%         vec = [vec;next,0];
% end
% 编写u，控制小车正方形行驶
u = [0,0,0,0,0,20,20,20,20]; %向前行驶0.475m
curr = [0,0,0,0,0,0,0,0,0,0,0,0];
vec = [curr,0];
speed = 0; %无速度控制
for i=0:0.01:1
    if i == 0
        next = NextState(curr,u,0.01,speed);
        vec = [vec;next,0];
    else
        next = NextState(next,u,0.01,speed);
        vec = [vec;next,0];
    end
end
u = [0,0,0,0,0,-12,12,12,-12]; %旋转90
for i=0:0.01:1
        next = NextState(next,u,0.01,speed);
        vec = [vec;next,0];
end
u = [0,0,0,0,0,20,20,20,20];  %再向前行驶0.475m
for i=0:0.01:1
        next = NextState(next,u,0.01,speed);
        vec = [vec;next,0];
end
u = [0,0,0,0,0,-20,20,-20,20];
for i=0:0.01:1
        next = NextState(next,u,0.01,speed);
        vec = [vec;next,0];
end
u = [0,0,0,0,0,-20,-20,-20,-20];  %再向前行驶0.475m
for i=0:0.01:1
        next = NextState(next,u,0.01,speed);
        vec = [vec;next,0];
end
u = [0,0,0,0,0,12,-12,-12,12]; %旋转90
for i=0:0.01:1
        next = NextState(next,u,0.01,speed);
        vec = [vec;next,0];
end
csvwrite('D:\test.csv',vec)