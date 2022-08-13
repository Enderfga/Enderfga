clc, clear, close all
%% Load Parameters
model_parameter
%% add spline library
%addpath('splines');
%% longitudinal direction

A_lon = [0 1;0 0];
B_lon = [0;ModelParams.Cm1/ModelParams.m];


%% lateral direction
vx = 5;
Kr = ModelParams.Dr*ModelParams.Cr*ModelParams.Br;
Kf = ModelParams.Df*ModelParams.Cf*ModelParams.Bf;

A_lat = [0 1 0 0;
    0 -2*(Kr+Kf)/ModelParams.m/vx 2*(Kr+Kf)/ModelParams.m -2*(ModelParams.lf*Kf-ModelParams.lr*Kr)/ModelParams.m/vx;
    0 0 0 1;
    0 -2*(ModelParams.lf*Kf-ModelParams.lr*Kr)/ModelParams.Iz/vx 2*(ModelParams.lf*Kf-ModelParams.lr*Kr)/ModelParams.Iz -2*(ModelParams.lf^2*Kf+ModelParams.lr^2*Kr)/ModelParams.Iz/vx];

B_lat = [0; 2*Kf/ModelParams.m; 0; 2*Kf*ModelParams.lf/ModelParams.Iz];

% rank(ctrb(A_lat,B_lat))

% Q_ctrl = diag([4,8,1,8]);
Q_ctrl = diag([0.5,1,0.5,1]);
R_ctrl = 15.0;
[ctrl_K,P,E] = lqr(A_lat, B_lat, Q_ctrl, R_ctrl);

% %% lqi
% C_lat = [1,0,0,0];
% sys_lat = ss(A_lat,B_lat,C_lat,[]);
% 
% Q_ctrl = diag([1,1,1,1,0.1]);
% R_ctrl = 0.01;
% [ctrl_K_lqi,P,E] = lqi(sys_lat, Q_ctrl, R_ctrl);

%% add trajectory
%读取路径文件
% traj=load('trajectory.txt');
load('traj_diy.mat');
load('out.mat');
out=[ans.X.Data,ans.Y.Data,ans.psi_unwrap.Data,ans.omega.Data];
% %% init path
% %% import an plot track
% % use normal ORCA Track
% load Tracks/track2.mat
% % shrink track by half of the car widht plus safety margin
% % TODO implement orientation depending shrinking in the MPC constraints
% safteyScaling = 1.5;
% [track,track2] = borderAdjustment(track2,ModelParams,safteyScaling);
% trackWidth = norm(track.inner(:,1)-track.outer(:,1));
% 
% % plot shrinked and not shrinked track 
% % figure(1);
% % plot(track.outer(1,:),track.outer(2,:),'r')
% % hold on
% % plot(track.inner(1,:),track.inner(2,:),'r')
% % plot(track2.outer(1,:),track2.outer(2,:),'k')
% % plot(track2.inner(1,:),track2.inner(2,:),'k')
% 
% %% Fit spline to track
% % TODO spline function only works with regular spaced points.
% % Fix add function which given any center line and bound generates equlally
% % space tracks.
% traj.id = 1;
% [traj, borders] =splinify(track);
% tl = traj.ppy.breaks(end);
% traj.ppx = rmfield(traj.ppx, 'form');
% traj.ppy = rmfield(traj.ppy, 'form');
% traj.dppx = rmfield(traj.dppx, 'form');
% traj.dppy = rmfield(traj.dppy, 'form');
% traj.ddppx = rmfield(traj.ddppx, 'form');
% traj.ddppy = rmfield(traj.ddppy, 'form');
% 
% % store all data in one struct
% % global path_info
% path = struct('traj',traj,'borders',borders,'track_center',track.center,'tl',tl);
% % save path_info.mat path_info
% 
% traj_info = Simulink.Bus.createObject(traj);
% traj_bus = evalin('base', traj_info.busName);


