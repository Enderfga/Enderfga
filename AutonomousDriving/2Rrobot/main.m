clc;clear;

%% 求约束下的临界时间
%使用了optimization toolbox
q0 = [10,20];
qv0 = [0,0];
qa0 = [0,0];
qf = [60,100];
qvf = [0,0];
qaf = [0,0];
%syms tf;% 没有解析解
x0.tf=31;
tf = optimvar('tf','Type','integer','LowerBound',x0.tf);
prob = optimproblem('ObjectiveSense','min');
prob.Objective = tf;
nn = length(q0);
for i=1:nn
	  a0(i) = q0(i);                                       
      a1(i) = qv0(i);
      a2(i) = qa0(i)/2.0;
      a3(i) = (20*(qf(i) - q0(i)) - (8*qvf(i) + 12*qv0(i))*tf + (qaf(i) - 3*qa0(i))*tf^2)/(2*tf^3);
      a4(i) = (-30*(qf(i) - q0(i)) + (14*qvf(i) + 16*qv0(i))*tf - (2*qaf(i) - 3*qa0(i))*tf^2)/(2*tf^4);
      a5(i) = (12*(qf(i) - q0(i)) - (60*qvf(i) + 6*qv0(i))*tf + (qaf(i) - qa0(i))*tf^2)/(2*tf^5);
end


for j=1:nn
    prob.Constraints.cons1 =  a1(j) + 2*a2(j)*tf + 3*a3(j)*tf^2 + 4*a4(j)*tf^3 + 5*a5(j)*tf^4 >= -5;
    prob.Constraints.cons2 =  2*a2(j) + 6*a3(j)*tf + 12*a4(j)*tf^2 + 20*a5(j)*tf^3 >= -0.5;
    prob.Constraints.cons3 =  a1(j) + 2*a2(j)*tf + 3*a3(j)*tf^2 + 4*a4(j)*tf^3 + 5*a5(j)*tf^4 <= 5;
    prob.Constraints.cons4 =  2*a2(j) + 6*a3(j)*tf + 12*a4(j)*tf^2 + 20*a5(j)*tf^3 <= 0.5;
    sol = solve(prob,x0,'Solver', 'ga');
end

%% 五次多项式
clc;clear;
figure('name','五次多项式');
a_array1 = 0;a_array2 = 0;%起止加速度值
t_array1=0;t_array2=31;%起止时间值
q5_s=[10,20];q5_f=[60,100];%起止角度值
v_array1=0;v_array2=0;%起止速度值

T=t_array2-t_array1;
for i=1:2
    a0(i)=q5_s(i);
    a1(i)=v_array1;
    a2(i)=a_array1/2;
    a3(i)=(20*q5_f(i)-20*q5_s(i)-(8*v_array2+12*v_array1)*T-(3*a_array1-a_array2)*T^2)/(2*T^3);
    a4(i)=(30*q5_s(i)-30*q5_f(i)+(14*v_array2+16*v_array1)*T+(3*a_array1-2*a_array2)*T^2)/(2*T^4);
    a5(i)=(12*q5_f(i)-12*q5_s(i)-(6*v_array2+6*v_array1)*T-(a_array1-a_array2)*T^2)/(2*T^5);%计算五次多项式系数 
end
tc=t_array1:0.01:t_array2;

    q1=a0(1)+a1(1)*tc+a2(1)*tc.^2+a3(1)*tc.^3+a4(1)*tc.^4+a5(1)*tc.^5;
    v1=a1(1)+2*a2(1)*tc+3*a3(1)*tc.^2+4*a4(1)*tc.^3+5*a5(1)*tc.^4;
    a1=2*a2(1)+6*a3(1)*tc+12*a4(1)*tc.^2+20*a5(1)*tc.^3;%位置，速度，加速度函数的计算
    q2=a0(2)+a1(2)*tc+a2(2)*tc.^2+a3(2)*tc.^3+a4(2)*tc.^4+a5(2)*tc.^5;
    v2=a1(2)+2*a2(2)*tc+3*a3(2)*tc.^2+4*a4(2)*tc.^3+5*a5(2)*tc.^4;
    a2=2*a2(2)+6*a3(2)*tc+12*a4(2)*tc.^2+20*a5(2)*tc.^3;

subplot(6,1,1),plot(tc,q1,'r'),xlabel('时间(s)'),ylabel('关节角曲线（°）');hold on;grid on;
subplot(6,1,2),plot(tc,v1,'b'),xlabel('时间(s)'),ylabel('关节角速度（°/s）');hold on;grid on;
subplot(6,1,3),plot(tc,a1,'g'),xlabel('时间(s)'),ylabel('关节角加速度(°/s^2)');hold on;grid on;
subplot(6,1,4),plot(tc,q2,'r'),xlabel('时间(s)'),ylabel('关节角曲线（°）');hold on;grid on;
subplot(6,1,5),plot(tc,v2,'b'),xlabel('时间(s)'),ylabel('关节角速度（°/s）');hold on;grid on;
subplot(6,1,6),plot(tc,a2,'g'),xlabel('时间(s)'),ylabel('关节角加速度(°/s^2)');hold on;grid on;

%% 机器人状态需要使用助教提供的程序包


l1 = 1;
l2 = 1;
 
 qq1 = [10  20]*pi/180;
 qq2 = [60  100]*pi/180;



  pe_0 = fkine_2DOF(l1, l2, qq1(1), qq1(2));   %----------初始位置
  pe_f = fkine_2DOF(l1, l2, qq2(1), qq2(2));   %----------终止位置
 
 base0 = [0, 0]';%----------基座坐标系原点，用于后面绘图

    p1 = q1*pi/180;
    p2 = q2*pi/180;
    k = length(q1);
    for i=1:k
    pJ1_x(i) = l1*cos(p1(i));  %-----杆件1的末端
    pJ1_y(i) = l1*sin(p2(i));
    
     pJ2_x(i) = l1*cos(p1(i)) + l2*cos(p1(i) + p2(i)); %-----杆件2的末端，也即机械臂的末端
     pJ2_y(i) = l1*sin(p1(i)) + l2*sin(p1(i) + p2(i));
    end 



NN = k-1; 
delt_N = floor(NN/20);  %----绘制NN/20个状态
figure,
 for j = 1 :delt_N: NN  
   line([base0(1),pJ1_x(j)],[base0(2),pJ1_y(j)],'linewidth',3,'color','k'); hold on;
   line([pJ1_x(j),pJ2_x(j)],[pJ1_y(j),pJ2_y(j)],'linewidth',3,'color','k'); 
   plot(pJ2_x(j),pJ2_y(j),'r*'); plot(pJ1_x(j),pJ1_y(j),'r*');
 end

axis([-1 2 0 1.6]); box on;
function xe = fkine_2DOF(l1, l2, q1, q2)

    s1 = sin(q1); c1 = cos(q1);
    s12 = sin(q1+q2); c12 = cos(q1+q2); 
     pex = l1*c1 + l2*c12; 
     pey = l1*s1 + l2*s12;
     
     xe = [pex, pey]';
end
