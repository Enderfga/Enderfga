clc,clear,close all

% system parameter
k = 5;
sigma = 0.1;
delta = 0.1;
m1 = 2;
m2 = 1;

% Build the sys state space here, with states: x=[v1 v2 p1 p2]
% get your state space matrix
A = [ -(delta+sigma)/m1 sigma/m1 -k/m1 k/m1;
 sigma/m2 -(delta+sigma)/m2 k/m2 -k/m2;
 1 0 0 0;
 0 1 0 0 ] ;
B = [ 0; 1/m2; 0 ; 0 ] ;
C = [0 0 1 0;
     0 0 0 1];
G = eye(4);

BF = [ B G ];
DF = zeros(2,5);

% Verify the controllability and observability here
rank(ctrb(A,B));
rank(obsv(A,C));



% design your LQR here
Q = diag([2,2,1,1]);
R = 1;
[K,S,e] = lqr(A,B,Q,R);

% design your LQE here
Rxx = diag([2,2,1,1]);
Ruu = eye(2);
[L,P,E] = lqe(A,G,C,Rxx,Ruu);


