% traj=load('trajectory.txt');
load('traj_diy.mat');
traj_x=traj(1,:);%给定x坐标
traj_y=traj(2,:);%给定y坐标
traj_psi=traj(3,:);%给定航向角Psi
traj_curv=traj(4,:);%曲率
traj_inx=traj(5,:);
traj_iny=traj(6,:);
traj_outx=traj(7,:);
traj_outy=traj(8,:);

figure
% subplot(2,1,1)
plot(traj_x,traj_y,'--')
hold on
plot(out.simout.X.Data, out.simout.Y.Data, 'LineWidth', 1.5)
plot(traj_inx,traj_iny)
plot(traj_outx,traj_outy)
xlabel('traj_x');
ylabel('traj_y');
legend('base line','real traj')

% subplot(2,1,2)
% plot(traj_x,traj_curv)
% xlabel('traj_x');
% ylabel('traj curv');