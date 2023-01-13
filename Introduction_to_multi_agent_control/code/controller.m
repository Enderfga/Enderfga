function [F, M] = controller(t, s, s_des)

global params

m = params.mass;
g = params.grav;
I = params.I;

% s(1:3) current position
% s(4:6) current velocity
% s(7:10) current attitude quaternion
% s(11:13) current body angular velocity

% s_des(1:3) desire position
% s_des(4:6) desire velocity
% s_des(7:9) desire acceleration
% s_des(10) desire yaw
% s_des(11) desire yaw rate

F = 1.0; M = [0.0, 0.0, 0.0]'; % You should calculate the output F and M
debug_flag = 0;
%% errors 
e_p = s_des(1:3) - s(1:3);
e_v = s_des(4:6) - s(4:6);


T_pre = 0;
e_p_int = zeros(3,1);
phi_c_pre = 0;
theta_c_pre = 0;


dt = t - T_pre;
e_p_int =  dt * e_p +e_p_int;

%% position control
% parameters

kp = 1.5605;
k_p_d_3 = kp*35;
k_p_d_2 = kp*2.95;
k_p_d_1 = kp*2.99;
k_p_p_3 = kp*5000;
k_p_p_2 = kp*17.5;
k_p_p_1 = kp*17.5;
k_p_i_3 = 0.1;
k_p_i_2 = 0.1;
k_p_i_1 = 0.01;

% PID controller  p_ddot_c_i denotes \ddot{p}_{i,c} 
p_ddot_c_1 = s_des(7) + k_p_d_1*e_v(1) + k_p_p_1*e_p(1) + k_p_i_1*e_p_int(1);
p_ddot_c_2 = s_des(8) + k_p_d_2*e_v(2) + k_p_p_2*e_p(2) + k_p_i_2*e_p_int(2);
p_ddot_c_3 = s_des(9) + k_p_d_3*e_v(3) + k_p_p_3*e_p(3) + k_p_i_3*e_p_int(3); 
F = m*(g+p_ddot_c_3);
if debug_flag == 1
    disp(['x_dse ', num2str(s_des(7)),' x_ddot ',num2str(p_ddot_c_1)]);
    disp(['y_dse ', num2str(s_des(8)),' y_ddot ',num2str(p_ddot_c_2)]);
end
%% attitute control
% quaternion to phi, theta, psi
q = s(7:10);
[phi, theta, psi] = RotToRPY_ZXY(quaternion_to_R(q));

% dot phi, theta, psi
phi_dot = s(11);
theta_dot = s(12);
psi_dot = s(13);
omega = [s(11);s(12);s(13)];

% commanded phi, theta, psi
phi_c = 1/g*(p_ddot_c_1*sin(psi)-p_ddot_c_2*cos(psi));
theta_c = 1/g*(p_ddot_c_1*cos(psi)+p_ddot_c_2*sin(psi));
psi_c = s_des(10);

% commanded dot phi, theta, psi

phi_dot_c = EulerAngleClamp(phi_c - phi_c_pre)/dt;
theta_dot_c = EulerAngleClamp(theta_c -theta_c_pre)/dt;
phi_c_pre = phi_c;
theta_c_pre = theta_c;
psi_dot_c = s_des(11);

% parameters
ko = 10;
k_phi_p  = ko*2500;
k_theta_p = ko*850;
k_psi_p = ko*1000;
k_phi_d =ko*20.0;
k_theta_d = ko*20.0;
k_psi_d = ko*20.0;% K_d_the
% PID controller 
phi_ddot_c = k_phi_p*EulerAngleClamp(phi_c-phi)+k_phi_d*(phi_dot_c-phi_dot);
theta_ddot_c = k_theta_p*EulerAngleClamp(theta_c-theta)+k_theta_d*(theta_dot_c-theta_dot);
psi_ddot_c = k_psi_p*EulerAngleClamp(psi_c-psi)+k_psi_d*(psi_dot_c-psi_dot);
omega_dot_c =[phi_ddot_c;theta_ddot_c;psi_ddot_c];

M=I*omega_dot_c+cross(omega,I*omega);
end

function [result] =  EulerAngleClamp(angle)
result = atan2(sin(angle), cos(angle));
end
