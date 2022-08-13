clc,clear,close all

theta = -pi/2:0.005:3.4;
base = 12;
road_width = 1;
r=2-1.2.^sin(5*theta);
r_base = base*r;
r_inside = (base-road_width)*r;
r_outside = (base+road_width)*r;

x_base = r_base.*cos(theta);
y_base = r_base.*sin(theta);
x_base = x_base-x_base(1);
y_base = y_base-y_base(1);

%%
syms alpha
r_sym=2-1.2.^sin(5*alpha);
r_base_sym = base*r_sym;

x_base_sym = r_base_sym.*cos(alpha);
y_base_sym = r_base_sym.*sin(alpha);

x_dot = simplify(diff(x_base_sym, 'alpha'));
x_dot2 = simplify(diff(x_base_sym, 'alpha', 2));
y_dot = simplify(diff(y_base_sym, 'alpha'));
y_dot2 = simplify(diff(y_base_sym, 'alpha', 2));
% curvature calculate
% (x'y" - x"y')/((x')^2 + (y')^2)^(3/2)
curv_base_sym = (x_dot*y_dot2-x_dot2*y_dot)/((x_dot)^2 + (y_dot)^2)^(3/2);

alpha = theta;
curv_base = eval(curv_base_sym);

% calculate the yaw
yaw_sym = atan2(y_dot, x_dot);
yaw_base = eval(yaw_sym);

% calculate safe region
x_inside = x_base-road_width.*cos(yaw_base+pi/2);
y_inside = y_base-road_width.*sin(yaw_base+pi/2);

x_outside = x_base+road_width.*cos(yaw_base+pi/2);
y_outside = y_base+road_width.*sin(yaw_base+pi/2);


figure
plot(x_base,y_base)
hold on
plot(x_inside,y_inside)
plot(x_outside,y_outside)
legend('base','in','out')



traj(1,:) = x_base;
traj(2,:) = y_base;
traj(3,:) = yaw_base;
traj(4,:) = curv_base;
traj(5,:) = x_inside;
traj(6,:) = y_inside;
traj(7,:) = x_outside;
traj(8,:) = y_outside;

save traj_diy.mat traj 
