function [F, M] = controller1(t, s, s_des)

global params

m = params.mass;
g = params.grav;
I = params.I;

F = m*g; M = [0.0, 0.0, 0.0]'; % You should calculate the output F and M

%params
Kp_i = [4,4,15]*5;   %2           3  fast
Kd_i = [2,2,3]*5;  %0.6 soft   1.0
Kp_phi = 20*5; %20
Kd_phi = 6*5;  %4 fast
Kp_theta = 20*5;
Kd_theta = 6*5;
Kp_psi = 20*5;
Kd_psi = 3*5;
persistent sp_last;
if isempty(sp_last)
    sp_last  = s(1:6);
    sp = sp_last;
else
    sp = 0.9*s(1:6) + 0.1 * sp_last;
    sp_last = sp;
end
%position control
i = 1;
r2c = zeros(3,1);
while(i<4)
	r2c(i) = Kp_i(i) * (s_des(i) - sp(i)) + Kd_i(i) * (s_des(i+3) - sp(i+3));
	i = i + 1;
end
F = m * (g + r2c(3));

%attitude control
q = s(7:10);
[phi,theta,psi] = RotToRPY_ZXY(quaternion_to_R(q));

persistent phi_last;
persistent theta_last;
persistent psi_last;
if isempty(phi_last)
    phi_last = phi;
    theta_last = theta;
    psi_last = psi;
else
    phi = 0.1*phi_last + 0.9*phi;
    theta = 0.1*theta_last + 0.9*theta;
    psi = 0.1*psi_last + 0.9*psi;
    phi_last = phi;
    theta_last = theta;
    psi_last = psi;
end

phi_c = (r2c(1)*sin(psi) - r2c(2)*cos(psi))/g;
theta_c = (r2c(1)*cos(psi) + r2c(2)*sin(psi))/g;

persistent phi_error_last theta_error_last;
persistent psi_error_last;
persistent t_last;

phi_error = phi_c - phi;
theta_error = theta_c - theta;
q_des = s_des(7:10);
[phi_des,theta_des,psi_des] = RotToRPY_ZXY(quaternion_to_R(q_des)');
psi_error = psi_des - psi;
if psi_error < -pi
    psi_error = psi_error + 2*pi;
else 
    if psi_error > pi
        psi_error = psi_error - 2*pi;
    end
end
if isempty(phi_error_last)
	phi_error_last = phi_error;
	theta_error_last = theta_error;
	psi_error_last = psi_error;
	t_last = t;
else
	phi_c2 = Kp_phi*(phi_error) + Kd_phi*(phi_error - phi_error_last)/(t - t_last);
	theta_c2 = Kp_theta*(theta_error) + Kd_theta*(theta_error - theta_error_last)/(t - t_last); 
	psi_c2 = Kp_psi*(psi_error) + Kd_psi*(psi_error - psi_error_last)/(t - t_last);
	
	phi_error_last = phi_error;
	theta_error_last = theta_error;
	psi_error_last = psi_error;
	t_last = t;
	angle_c2 = [phi_c2,
				theta_c2,
				psi_c2];
    %output filter
    persistent phi_c2_last;
    persistent theta_c2_last;
    persistent psi_c2_last;
    if isempty(phi_c2_last)
        phi_c2_last = phi_c2;
        theta_c2_last = theta_c2;
        psi_c2_last = psi_c2;
    else
    	phi_c2 = 0.1*phi_c2_last + 0.9*phi_c2;
    	theta_c2 = 0.1*theta_c2_last + 0.9*theta_c2;
    	psi_c2 = 0.1*psi_c2_last + 0.9*psi_c2;
    	phi_c2_last = phi_c2;
    	theta_c2_last = theta_c2;
    	psi_c2_last = psi_c2;
    end
	w = s(11:13);
	M = I * angle_c2 + cross(w,I*w);
end


end
