clear
clc
close all

%% modify ode45 options to form SYSU, the formation may fail due to the ode45 accuracy and formation init position,especially for y->s
opts = odeset('NormControl', 'on', 'Reltol',1e-12,'AbsTol',1e-12, 'Stats','on');

%% Parameter Setting
n = 6; % Number of agents
kv = 1.5; % Control gain kv

% connection matrix
Adj = [0, 1, 1, 0, 0, 0; ...
    1, 0, 1, 0, 0, 1; ...
    1, 1, 0, 1, 0, 1; ...
    0, 0, 1, 0, 1, 1; ...
    0, 0, 0, 1, 0, 1; ...
    0, 1, 1, 1, 1, 0];


tfinal = 2; % Simulation ending time
h = 1e-1; % 1e-2                 % ODE step

% Encapusulate the paremeters into a structure 'para'
para.n = n;
para.kv = kv;
para.Adj = Adj;

% An example initial conditions: q_0 is initial positions and q_0(:,i) is
% the coordinates for the ith agent;

% 修改了初始位置坐标
q_0 = [-0.15, 0.15, -0.15, -0.15, 0.15, 0.15; ...
    0.25, 0.45, 0, -0.45, -0.25, 0];

%% ODE
q_0_vec = reshape(q_0, 1, []); % reshape q_0 into a 2nx1 vector
time_span = 0:h:tfinal; % simulation time span
[t, q] = ode45(@SI_dynamic_fomation_manv_func, time_span, q_0_vec, opts, para, Adj, 'S');

xx = q(:, 2*(0:n - 1)+1);
yy = q(:, 2*(0:n - 1)+2);

% %% Retrieve the control input
% u = zeros(2*n, length(t)); % Control Input
% for ii = 1:length(t) % loop for time from 0 to tfinal
%     e = zeros(n, n); % initialize distance error
%     dv = zeros(2*n-3, 1); % initialize dv
%     z = zeros(2*n-3, 1); % initialize z
%     R = zeros(2*n-3, 2*n); % initialize Rigidity Matrix
%     [d, d_dot] = Desired_tv_distance(t(ii), n, Adj);
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     % Construct R, e, and z
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     ord = 1;
%     for i = 1:n - 1
%         for j = i + 1:n
%             e(i, j) = sqrt((xx(ii, i) - xx(ii, j))^2+(yy(ii, i) - yy(ii, j))^2) ...
%                 -d(i, j);
%             if Adj(i, j) == 1
%                 dv(ord) = d(i, j) * d_dot(i, j);
%                 z(ord) = e(i, j) * (e(i, j) + 2 * d(i, j));
%                 R(ord, 2*i-1:2*i) = [xx(ii, i) - xx(ii, j), yy(ii, i) - yy(ii, j)];
%                 R(ord, 2*j-1:2*j) = [xx(ii, j) - xx(ii, i), yy(ii, j) - yy(ii, i)];
%                 ord = ord + 1;
%             end
%         end
%     end
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     vd = Desired_velocity(t(ii)); % Set desired velocity by function
%     % maneuvering control input for single integrator model
%     %     u(:,ii) = -kv*R'*z;
% 
%     u(:, ii) = R' * pinv(R*R') * (-kv * z + dv) + kron(ones(n, 1), vd);
% end
% 
% %% Calculate distance errors (e12,e13...)
% d = zeros(length(t), n, n);
% for ii = 1:length(t)
%     [d(ii, :, :), ~] = Desired_tv_distance(t(ii), n, Adj);
% end
% for i = 1:n - 1
%     for j = i + 1:n
%         eval(['e', int2str(i), int2str(j), ...
%             '=sqrt((xx(:,i)-xx(:,j)).^2+(yy(:,i)-yy(:,j)).^2)-d(:,i,j);'])
%     end
% end

disp('Simulation complete S!')


%% fomation Y 
%% connection matrix Y
Adj_Y = [0, 1, 1, 1, 1, 0; ...
    1, 0, 1, 0, 0, 1; ...
    1, 1, 0, 1, 0, 0; ...
    1, 0, 1, 0, 0, 1; ...
    1, 0, 0, 0, 0, 1; ...
    0, 1, 0, 1, 1, 0];

%% S last position is Y first position
q_0_Y = [xx(length(t), 1), xx(length(t), 2), xx(length(t), 3), xx(length(t), 4), xx(length(t), 5), xx(length(t), 6); ...
    yy(length(t), 1), yy(length(t), 2), yy(length(t), 3), yy(length(t), 4), yy(length(t), 5), yy(length(t), 6)];

%% ODE  
q_0_vec_Y = reshape(q_0_Y, 1, []); % reshape q_0 into a 2nx1 vector
time_span = 0:h:tfinal; % simulation time span
[t, q_Y] = ode45(@SI_dynamic_fomation_manv_func, time_span, q_0_vec_Y, opts, para, Adj_Y, 'Y');

xx_Y = q_Y(:, 2*(0:n - 1)+1);
yy_Y = q_Y(:, 2*(0:n - 1)+2);
disp('Simulation complete Y!')

% %% Retrieve the control input
% u_y = zeros(2*n, length(t)); % Control Input
% for ii = 1:length(t) % loop for time from 0 to tfinal
%     e = zeros(n, n); % initialize distance error
%     dv = zeros(2*n-3, 1); % initialize dv
%     z = zeros(2*n-3, 1); % initialize z
%     R = zeros(2*n-3, 2*n); % initialize Rigidity Matrix
%     [d, d_dot] = Desired_Y_distance(t(ii), n, Adj_Y);
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     % Construct R, e, and z
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     ord = 1;
%     for i = 1:n - 1
%         for j = i + 1:n
%             e(i, j) = sqrt((xx_Y(ii, i) - xx_Y(ii, j))^2+(yy_Y(ii, i) - yy_Y(ii, j))^2) ...
%                 -d(i, j);
%             if Adj_Y(i, j) == 1
%                 dv(ord) = d(i, j) * d_dot(i, j);
%                 z(ord) = e(i, j) * (e(i, j) + 2 * d(i, j));
%                 R(ord, 2*i-1:2*i) = [xx_Y(ii, i) - xx_Y(ii, j), yy_Y(ii, i) - yy_Y(ii, j)];
%                 R(ord, 2*j-1:2*j) = [xx_Y(ii, j) - xx_Y(ii, i), yy_Y(ii, j) - yy_Y(ii, i)];
%                 ord = ord + 1;
%             end
%         end
%     end
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     vd = Desired_velocity(t(ii)); % Set desired velocity by function
%     % maneuvering control input for single integrator model
%     u_y(:, ii) = R' * pinv(R*R') * (-kv * z + dv) + kron(ones(n, 1), vd);
% end


%% fomation S
%% connection matrix S

Adj_S = [0, 1, 1, 0, 0, 0; ...
    1, 0, 1, 0, 0, 1; ...
    1, 1, 0, 1, 0, 1; ...
    0, 0, 1, 0, 1, 1; ...
    0, 0, 0, 1, 0, 1; ...
    0, 1, 1, 1, 1, 0];

q_0_S = [xx_Y(length(t), 1), xx_Y(length(t), 2), xx_Y(length(t), 3), xx_Y(length(t), 4), xx_Y(length(t), 5), xx_Y(length(t), 6); ...
    yy_Y(length(t), 1), yy_Y(length(t), 2), yy_Y(length(t), 3), yy_Y(length(t), 4), yy_Y(length(t), 5), yy_Y(length(t), 6)];

%% ODE
q_0_vec_S = reshape(q_0_S, 1, []); % reshape q_0 into a 2nx1 vector
time_span = 0:h:tfinal; % simulation time span
[t, q] = ode45(@SI_dynamic_fomation_manv_func, time_span, q_0_vec_S, opts, para, Adj_S, 'S');

xx_S = q(:, 2*(0:n - 1)+1);
yy_S = q(:, 2*(0:n - 1)+2);

% %% Retrieve the control input
% u_s = zeros(2*n, length(t)); % Control Input
% for ii = 1:length(t) % loop for time from 0 to tfinal
%     e = zeros(n, n); % initialize distance error
%     dv = zeros(2*n-3, 1); % initialize dv
%     z = zeros(2*n-3, 1); % initialize z
%     R = zeros(2*n-3, 2*n); % initialize Rigidity Matrix
%     [d, d_dot] = Desired_tv_distance(t(ii), n, Adj);
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     % Construct R, e, and z
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     ord = 1;
%     for i = 1:n - 1
%         for j = i + 1:n
%             e(i, j) = sqrt((xx_S(ii, i) - xx_S(ii, j))^2+(yy_S(ii, i) - yy_S(ii, j))^2) ...
%                 -d(i, j);
%             if Adj_S(i, j) == 1
%                 dv(ord) = d(i, j) * d_dot(i, j);
%                 z(ord) = e(i, j) * (e(i, j) + 2 * d(i, j));
%                 R(ord, 2*i-1:2*i) = [xx_S(ii, i) - xx_S(ii, j), yy_S(ii, i) - yy_S(ii, j)];
%                 R(ord, 2*j-1:2*j) = [xx_S(ii, j) - xx_S(ii, i), yy_S(ii, j) - yy_S(ii, i)];
%                 ord = ord + 1;
%             end
%         end
%     end
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     vd = Desired_velocity(t(ii)); % Set desired velocity by function
%     % maneuvering control input for single integrator model
%     u_s(:, ii) = R' * pinv(R*R') * (-kv * z + dv) + kron(ones(n, 1), vd);
% end
% 
% %% Calculate distance errors (e12,e13...)
% d = zeros(length(t), n, n);
% for ii = 1:length(t)
%     [d(ii, :, :), ~] = Desired_tv_distance(t(ii), n, Adj_S);
% end
% for i = 1:n - 1
%     for j = i + 1:n
%         eval(['e', int2str(i), int2str(j), ...
%             '=sqrt((xx_S(:,i)-xx_S(:,j)).^2+(yy_S(:,i)-yy_S(:,j)).^2)-d(:,i,j);'])
%     end
% end

disp('Simulation complete S!')

%% fomation U
%% connection matrix U

%% connection matrix
Adj_U = [0, 1, 1, 1, 0, 1; ...
    1, 0, 1, 0, 1, 0; ...
    1, 1, 0, 1, 0, 0; ...
    1, 0, 1, 0, 1, 0; ...
    0, 1, 0, 1, 0, 1; ...
    1, 0, 0, 0, 1, 0];
q_0_U = [xx_S(length(t), 1), xx_S(length(t), 2), xx_S(length(t), 3), xx_S(length(t), 4), xx_S(length(t), 5), xx_S(length(t), 6); ...
    yy_S(length(t), 1), yy_S(length(t), 2), yy_S(length(t), 3), yy_S(length(t), 4), yy_S(length(t), 5), yy_S(length(t), 6)];

%% ODE
q_0_vec_U = reshape(q_0_U, 1, []); % reshape q_0 into a 2nx1 vector
time_span = 0:h:tfinal; % simulation time span
[t, q_U] = ode45(@SI_dynamic_fomation_manv_func, time_span, q_0_vec_U, opts, para, Adj_U, 'U');

xx_U = q_U(:, 2*(0:n - 1)+1);
yy_U = q_U(:, 2*(0:n - 1)+2);

disp('Simulation complete U!')

% %% Retrieve the control input
% u_u = zeros(2*n, length(t)); % Control Input
% for ii = 1:length(t) % loop for time from 0 to tfinal
%     e = zeros(n, n); % initialize distance error
%     dv = zeros(2*n-3, 1); % initialize dv
%     z = zeros(2*n-3, 1); % initialize z
%     R = zeros(2*n-3, 2*n); % initialize Rigidity Matrix
%     [d, d_dot] = Desired_U_distance(t(ii), n, Adj);
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     % Construct R, e, and z
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     ord = 1;
%     for i = 1:n - 1
%         for j = i + 1:n
%             e(i, j) = sqrt((xx_U(ii, i) - xx_U(ii, j))^2+(yy_U(ii, i) - yy_U(ii, j))^2) ...
%                 -d(i, j);
%             if Adj_U(i, j) == 1
%                 dv(ord) = d(i, j) * d_dot(i, j);
%                 z(ord) = e(i, j) * (e(i, j) + 2 * d(i, j));
%                 R(ord, 2*i-1:2*i) = [xx_U(ii, i) - xx_U(ii, j), yy_U(ii, i) - yy_U(ii, j)];
%                 R(ord, 2*j-1:2*j) = [xx_U(ii, j) - xx_U(ii, i), yy_U(ii, j) - yy_U(ii, i)];
%                 ord = ord + 1;
%             end
%         end
%     end
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     vd = Desired_velocity(t(ii)); % Set desired velocity by function
%     % maneuvering control input for single integrator model
%     u_u(:, ii) = R' * pinv(R*R') * (-kv * z + dv) + kron(ones(n, 1), vd);
% end


x = [xx; xx_Y; xx_S; xx_U];
y = [yy; yy_Y; yy_S; yy_U];



% save variables for plot and animation
save('SI_dynamic_fomation_manv_results.mat')
disp('Simulation complete!')
