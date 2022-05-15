%% 五次多项式
figure('name','五次多项式');
a_array1 = 0;a_array2 = 0;%起止加速度值
t_array1=0;t_array2=30;%起止时间值
q5_s=20;q5_f=100;%起止角度值
v_array1=0;v_array2=0;%起止速度值

T=t_array2-t_array1
a0=q5_s;
a1=v_array1;
a2=a_array1/2;
a3=(20*q5_f-20*q5_s-(8*v_array2+12*v_array1)*T-(3*a_array1-a_array2)*T^2)/(2*T^3);
a4=(30*q5_s-30*q5_f+(14*v_array2+16*v_array1)*T+(3*a_array1-2*a_array2)*T^2)/(2*T^4);
a5=(12*q5_f-12*q5_s-(6*v_array2+6*v_array1)*T-(a_array1-a_array2)*T^2)/(2*T^5);%计算五次多项式系数 

tc=t_array1:0.01:t_array2;
q=a0+a1*tc+a2*tc.^2+a3*tc.^3+a4*tc.^4+a5*tc.^5;
v=a1+2*a2*tc+3*a3*tc.^2+4*a4*tc.^3+5*a5*tc.^4;
a=2*a2+6*a3*tc+12*a4*tc.^2+20*a5*tc.^3;%位置，速度，加速度函数的计算
ad = 6*a3 + 24*a4*tc + 60*a5*tc.^2;
subplot(3,1,1),plot(tc,q,'r'),xlabel('时间(s)'),ylabel('关节角曲线（°）');hold on;grid on;
%plot(t_array1,q_array1,'*','color','k');plot(t_array2,q_array2,'*','color','b');
subplot(3,1,2),plot(tc,v,'b'),xlabel('时间(s)'),ylabel('关节角速度（°/s）');hold on;grid on;
%plot(t_array1,v_array1,'*','color','k'),plot(t_array2,v_array2,'*','color','b');
subplot(3,1,3),plot(tc,a,'g'),xlabel('时间(s)'),ylabel('关节角加速度(°/s^2)');hold on;grid on;


%机器人状态需要使用助教提供的程序包
clear;
clc;

l1 = 1;
l2 = 1;

t0 = 0;
tf = 30;

qq1 = [10  20]*pi/180;
qq2 = [60  100]*pi/180;



 pe_0 = fkine_2DOF(l1, l2, qq1(1), qq1(2));   %----------初始位置
 pe_f = fkine_2DOF(l1, l2, qq2(1), qq2(2));   %----------终止位置
 
 base0 = [0, 0]';%----------基座坐标系原点，用于后面绘图

  qr = qq1;     %------------求逆解时的参考臂型----
  
  t = t0;
  dt = 0.1;    %-----规划的时间间隔(采样、控制周期)
  k = 1;
while (t<=tf)   

    tau = (t - t0)/(tf - t0);         %---------归一化的时间尺度 tau在[0, 1]之间，对应t0~tf    
     lamda = 10*tau^3 - 15*tau^4 + 6*tau^5 ;    %---------采用五次多项式的情况----------------------   

    pe_t = pe_0 + lamda*(pe_f - pe_0); 
    
    tt(k) = t;
    xe_t(k) = pe_t(1);
    ye_t(k) = pe_t(2);
    
    
    theta = ikine_2DOF_fcn(xe_t(k), ye_t(k), qr, l1, l2);
    
    q1 = theta(1);
    q2 = theta(2);
    
    q1_k(k) = q1;
    q2_k(k) = q2;
    
    pJ1_x(k) = l1*cos(q1);  %-----杆件1的末端
    pJ1_y(k) = l1*sin(q1);
    
     pJ2_x(k) = l1*cos(q1) + l2*cos(q1 + q2); %-----杆件2的末端，也即机械臂的末端
     pJ2_y(k) = l1*sin(q1) + l2*sin(q1 + q2);
     
     qr = theta;
  
    
   k=k+1; 
   t = t + dt;  
   
end

% tt = 0: dt: tf;

NN = k-1; 
delt_N = floor(NN/20);  %----绘制NN/20个状态
figure,
 for j = 1 :delt_N: NN  
   line([base0(1),pJ1_x(j)],[base0(2),pJ1_y(j)],'linewidth',3,'color','k'); hold on;
   line([pJ1_x(j),pJ2_x(j)],[pJ1_y(j),pJ2_y(j)],'linewidth',3,'color','k'); plot(pJ2_x(j),pJ2_y(j),'r*'); plot(pJ1_x(j),pJ1_y(j),'r*');
 end

line([pe_0(1),pe_f(1)],[pe_0(2),pe_f(2)],'linewidth',1,'color','k'); ylabel('y/m');xlabel('x/m');
axis([-1 2 -0.5 1.4]); box on; 
