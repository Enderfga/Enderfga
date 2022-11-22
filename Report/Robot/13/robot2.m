clc;clear;
Tseinitial = [0,0,1,0.5518;0,-1,0,0.0;-1,0,0,0.4012;0,0,0,1];
Tscinitial = [cos(0),-sin(0),0,1.0;sin(0),cos(0),0,0.0;0,0,1,0.0250;0,0,0,1];
Tscfinal = [cos(-pi/2),-sin(-pi/2),0,0.0;sin(-pi/2),cos(-pi/2),0,-1.0;0,0,1,0.0250;0,0,0,1];
Tcegrasp = [cos(3*pi/4),0,sin(3*pi/4),0.0050;0,1,0.0,0.0;-sin(3*pi/4),0,cos(3*pi/4),-0.005;0,0,0,1];
Tcestandoff = Tcegrasp;
Tcestandoff(3,4) = 0.05;
k = 100;
traj = TrajectoryGenerator(Tseinitial, Tscinitial,Tscfinal, Tcegrasp, Tcestandoff, k);
csvwrite('D:\test.csv',traj)
