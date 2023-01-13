% written by Daniel Mellinger
% July 1, 2011
% 
% For details of the controller see the paper:
% 
% Daniel Mellinger, Nathan Michael, and Vijay Kumar. 
% Trajectory Generation and Control for Precise Aggressive Maneuvers with Quadrotors. 
% Int. Symposium on Experimental Robotics, Dec 2010.
% 
% For more info take a look at some of the papers posted here:
% 
% https://fling.seas.upenn.edu/~dmel/wiki/index.php?n=Main.Publications

function params = quadModel_readonly()

m = 0.5;
g = 9.81;
I = [2.32e-3,0,0;0,2.32e-3,0;0,0,4e-3];
params.mass = m;
params.I = I;
params.invI = inv(I);
params.grav = g;

params.maxangle = 40*pi/180; %you can specify the maximum commanded angle here
params.maxF = 2.5*m*g;
params.minF = 0.05*m*g;


%armlength is the distance from the center of the craft to the prop center
params.kforce = 6.11e-8; %in Newton/rpm^2
params.kmoment = 1.5e-9; %in Newton*meter/rpm^2
params.armlength = 0.175; %in meters

params.FM_omega2 = [params.kforce,params.kforce,params.kforce,params.kforce;...
    0,params.armlength*params.kforce,0,-params.armlength*params.kforce;...
    -params.armlength*params.kforce,0,params.armlength*params.kforce,0;...
    params.kmoment,-params.kmoment,params.kmoment,-params.kmoment];

params.omega2_FM = inv(params.FM_omega2);

params.maxomega = sqrt(params.maxF/(4*params.kforce));
params.minomega = sqrt(params.minF/(4*params.kforce));
