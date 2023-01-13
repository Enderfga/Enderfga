% Used for HKUST ELEC 5660

function run6formation(h1, h2, h3, h4, h5, h6, h7, h8, h9, h10, h11, h12, ...
    h13, h14, h15, h16, h17, h18, h19, h20, h21, h22, h23, h24, h25, h26, ...
    h27, h28, h29, h30, h31, h32, h33, h34, h35, h36, h37, h38, h39, h40, ...
    h41, h42, h43, h44, h45, h46, h47, h48, h49,flag)
if flag == 1
    h1 = subplot(1,1,1);
end
addpath('./SI_DFM_2D_SYSU','./readonly','utils')
load 'SI_dynamic_fomation_manv_results.mat'

% Sensor parameters
fnoise = 0; % Standard deviation of gaussian noise for external disturbance (N)
ifov = 90; % Camera field of view

% Initialize simulation
global params;
params = quadModel_readonly(); % Quad model

yaw0 = 0 * pi / 180;
pitch0 = 0 * pi / 180;
roll0 = 0 * pi / 180;
Quat0 = R_to_quaternion(ypr_to_R([yaw0, pitch0, roll0])');

%% quadrotor true states initialize
x0 = [-0.15, 0.15, -0.15, -0.15, 0.15, 0.15; ...
    0.25, 0.45, 0, -0.45, -0.25, 0; ...
    1, 1, 1, 1, 1, 1; ...
    0, 0, 0, 0, 0, 0; ...
    0, 0, 0, 0, 0, 0; ...
    0, 0, 0, 0, 0, 0; ...
    Quat0(1), Quat0(1), Quat0(1), Quat0(1), Quat0(1), Quat0(1); ...
    Quat0(2), Quat0(2), Quat0(2), Quat0(2), Quat0(2), Quat0(2); ...
    Quat0(3), Quat0(3), Quat0(3), Quat0(3), Quat0(3), Quat0(3); ...
    Quat0(4), Quat0(4), Quat0(4), Quat0(4), Quat0(4), Quat0(4); ...
    0, 0, 0, 0, 0, 0; ...
    0, 0, 0, 0, 0, 0; ...
    0, 0, 0, 0, 0, 0];

true_s = x0; % true state
F1 = params.mass * params.grav;
M1 = [0; 0; 0];

F2 = params.mass * params.grav;
M2 = [0; 0; 0];

F3 = params.mass * params.grav;
M3 = [0; 0; 0];

F4 = params.mass * params.grav;
M4 = [0; 0; 0];

F5 = params.mass * params.grav;
M5 = [0; 0; 0];

F6 = params.mass * params.grav;
M6 = [0; 0; 0];

% Time
tstep = 0.002; % Time step for solving equations of motion // FIXME: not 0.01
cstep = 0.01; % Period of calling student code
vstep = 0.05; % visualization interval
time     = 0; % current time
vis_time = 0; % Time of last visualization
time_tol = 7.5; % Maximum time that the quadrotor is allowed to fly

% Visualization
vis_init = false;


% h1
thprop1 = [];
thprop2 = [];
thprop3 = [];
thprop4 = [];
tharm1 = [];
tharm2 = [];
thfov1 = [];
thfov2 = [];
thfov3 = [];
thfov4 = [];
ehprop1 = [];
ehprop2 = [];
ehprop3 = [];
ehprop4 = [];
eharm1 = [];
eharm2 = [];
ehmap = [];
ehwindow = [];

% h2 h3
thpitch = [];
throll = [];

% Start Simulation run_trajectory_readonly
disp('Start Simulation ...');
while (1)

    % External disturbance
    Fd = randn(3, 1) * fnoise;

    % Run simulation for cstep
    timeint = time:tstep:time + cstep;
    [~, xsave] = ode45(@(t, s) quadEOM_readonly(t, s, F1, M1, Fd), timeint', true_s(:, 1));
    true_s(:, 1) = xsave(end, :)';

    [~, xsave] = ode45(@(t, s) quadEOM_readonly(t, s, F2, M2, Fd), timeint', true_s(:, 2));
    true_s(:, 2) = xsave(end, :)';

    [~, xsave] = ode45(@(t, s) quadEOM_readonly(t, s, F3, M3, Fd), timeint', true_s(:, 3));
    true_s(:, 3) = xsave(end, :)';

    [~, xsave] = ode45(@(t, s) quadEOM_readonly(t, s, F4, M4, Fd), timeint', true_s(:, 4));
    true_s(:, 4) = xsave(end, :)';

    [~, xsave] = ode45(@(t, s) quadEOM_readonly(t, s, F5, M5, Fd), timeint', true_s(:, 5));
    true_s(:, 5) = xsave(end, :)';

    [~, xsave] = ode45(@(t, s) quadEOM_readonly(t, s, F6, M6, Fd), timeint', true_s(:, 6));
    true_s(:, 6) = xsave(end, :)';

    time = time + cstep;

    i = ceil(time/0.1);


    s_des = [x(i, 1), x(i, 2), x(i, 3), x(i, 4), x(i, 5), x(i, 6); ...
        y(i, 1), y(i, 2), y(i, 3), y(i, 4), y(i, 5), y(i, 6); ...
        1, 1, 1, 1, 1, 1; ...
        0, 0, 0, 0, 0, 0; ...
        0, 0, 0, 0, 0, 0; ...
        0, 0, 0, 0, 0, 0; ...
        1, 1, 1, 1, 1, 1; ...
        0, 0, 0, 0, 0, 0; ...
        0, 0, 0, 0, 0, 0; ...
        0, 0, 0, 0, 0, 0; ...
        0, 0, 0, 0, 0, 0; ...
        0, 0, 0, 0, 0, 0; ...
        0, 0, 0, 0, 0, 0];


    [F1, M1] = controller(time , true_s(:, 1), s_des(:, 1));

    [F2, M2] = controller(time , true_s(:, 2), s_des(:, 2));

    [F3, M3] = controller(time , true_s(:, 3), s_des(:, 3));

    [F4, M4] = controller(time , true_s(:, 4), s_des(:, 4));

    [F5, M5] = controller(time , true_s(:, 5), s_des(:, 5));

    [F6, M6] = controller(time , true_s(:, 6), s_des(:, 6));

    if (i >= length(t)*4) || (time >= time_tol)
        if flag ~= 1
           save('./readonly/6formation_results.mat', 'time','thtraj1', 'ehtraj1',  'thtraj2', 'ehtraj2', 'thtraj3', 'ehtraj3', ...
                'thtraj4', 'ehtraj4','thtraj5', 'ehtraj5', 'thtraj6', 'ehtraj6', 'thvx1', 'ehvx1', 'thvx2', 'ehvx2','thvx3', 'ehvx3', ...
                'thvx4', 'ehvx4','thvx5', 'ehvx5','thvx6', 'ehvx6','thvy1', 'ehvy1','thvy2', 'ehvy2','thvy3', 'ehvy3','thvy4', 'ehvy4', ...
                'thvy5', 'ehvy5', 'thvy6', 'ehvy6', 'x0');
        else
            save('./readonly/6formation_results.mat', 'time','thtraj1', 'ehtraj1',  'thtraj2', 'ehtraj2', 'thtraj3', 'ehtraj3', ...
                'thtraj4', 'ehtraj4','thtraj5', 'ehtraj5', 'thtraj6', 'ehtraj6', 'x0');
        end
       disp("simulation complete!");
        break;
    end

    %% Rlot Results
    if time - vis_time > vstep

        %% Plot quad, fov, and estimated quad, estimated_map, and sliding window
        subplot(h1);
        hold on;
        if ~vis_init
            grid on;
            %axis equal;
            %axis ([-5 5 -2 12 -1 4]);
            %axis auto
        end
        %% at special time plot S Y S U 
        if (i == 17)
            line([s_des(1, 2), s_des(1, 1)], [s_des(2, 2), s_des(2, 1)], 'Color', [0.5, 0.5, 1], 'LineWidth', 3);
            line([s_des(1, 1), s_des(1, 3)], [s_des(2, 1), s_des(2, 3)], 'Color', [0.5, 0.5, 1], 'LineWidth', 3);
            line([s_des(1, 3), s_des(1, 6)], [s_des(2, 3), s_des(2, 6)], 'Color', [0.5, 0.5, 1], 'LineWidth', 3);
            line([s_des(1, 6), s_des(1, 5)], [s_des(2, 6), s_des(2, 5)], 'Color', [0.5, 0.5, 1], 'LineWidth', 3);
            line([s_des(1, 5), s_des(1, 4)], [s_des(2, 5), s_des(2, 4)], 'Color', [0.5, 0.5, 1], 'LineWidth', 3);

        elseif (i == 35)
            line([s_des(1, 3), s_des(1, 1)], [s_des(2, 3), s_des(2, 1)], 'Color', [0.5, 0.5, 1], 'LineWidth', 3);
            line([s_des(1, 2), s_des(1, 3)], [s_des(2, 2), s_des(2, 3)], 'Color', [0.5, 0.5, 1], 'LineWidth', 3);
            line([s_des(1, 3), s_des(1, 4)], [s_des(2, 3), s_des(2, 4)], 'Color', [0.5, 0.5, 1], 'LineWidth', 3);
           
        elseif (i == 50)
            line([s_des(1, 2), s_des(1, 1)], [s_des(2, 2), s_des(2, 1)], 'Color', [0.5, 0.5, 1], 'LineWidth', 3);
            line([s_des(1, 1), s_des(1, 3)], [s_des(2, 1), s_des(2, 3)], 'Color', [0.5, 0.5, 1], 'LineWidth', 3);
            line([s_des(1, 3), s_des(1, 6)], [s_des(2, 3), s_des(2, 6)], 'Color', [0.5, 0.5, 1], 'LineWidth', 3);
            line([s_des(1, 6), s_des(1, 5)], [s_des(2, 6), s_des(2, 5)], 'Color', [0.5, 0.5, 1], 'LineWidth', 3);
            line([s_des(1, 5), s_des(1, 4)], [s_des(2, 5), s_des(2, 4)], 'Color', [0.5, 0.5, 1], 'LineWidth', 3);

        elseif (i == 75)
            line([s_des(1, 2), s_des(1, 6)], [s_des(2, 2), s_des(2, 6)], 'Color', [0.5, 0.5, 1], 'LineWidth', 3);
            line([s_des(1, 1), s_des(1, 3)], [s_des(2, 1), s_des(2, 3)], 'Color', [0.5, 0.5, 1], 'LineWidth', 3);
            line([s_des(1, 3), s_des(1, 4)], [s_des(2, 3), s_des(2, 4)], 'Color', [0.5, 0.5, 1], 'LineWidth', 3);
            line([s_des(1, 4), s_des(1, 5)], [s_des(2, 4), s_des(2, 5)], 'Color', [0.5, 0.5, 1], 'LineWidth', 3);
            line([s_des(1, 5), s_des(1, 6)], [s_des(2, 5), s_des(2, 6)], 'Color', [0.5, 0.5, 1], 'LineWidth', 3);
        end
        plot3(s_des(1), s_des(2), s_des(3), 'm-');

        ll = 0.175 / 3;
        rr = 0.1 / 3;
        ff = 0.3 / 3;
        nprop = 40 / 4;
        propangs = linspace(0, 2*pi, nprop);
        tR = QuatToRot(true_s(7:10, 1))';
        tpoint1 = tR * [ll; 0; 0];
        tpoint2 = tR * [0; ll; 0];
        tpoint3 = tR * [-ll; 0; 0];
        tpoint4 = tR * [0; -ll; 0];
        tproppts = rr * tR * [cos(propangs); sin(propangs); zeros(1, nprop)];
        twp1 = true_s(1:3, 1) + tpoint1;
        twp2 = true_s(1:3, 1) + tpoint2;
        twp3 = true_s(1:3, 1) + tpoint3;
        twp4 = true_s(1:3, 1) + tpoint4;
        tprop1 = tproppts + twp1 * ones(1, nprop);
        tprop2 = tproppts + twp2 * ones(1, nprop);
        tprop3 = tproppts + twp3 * ones(1, nprop);
        tprop4 = tproppts + twp4 * ones(1, nprop);
        tfov0 = true_s(1:3, 1);
        tfov1 = tR * [ff; ff * tan(ifov*pi/180/2); ff * tan(ifov*pi/180/2)] + true_s(1:3, 1);
        tfov2 = tR * [ff; ff * tan(ifov*pi/180/2); -ff * tan(ifov*pi/180/2)] + true_s(1:3, 1);
        tfov3 = tR * [ff; -ff * tan(ifov*pi/180/2); -ff * tan(ifov*pi/180/2)] + true_s(1:3, 1);
        tfov4 = tR * [ff; -ff * tan(ifov*pi/180/2); ff * tan(ifov*pi/180/2)] + true_s(1:3, 1);
        eR = QuatToRot(s_des(7:10, 1))';
        epoint1 = eR * [ll; 0; 0];
        epoint2 = eR * [0; ll; 0];
        epoint3 = eR * [-ll; 0; 0];
        epoint4 = eR * [0; -ll; 0];
        eproppts = rr * eR * [cos(propangs); sin(propangs); zeros(1, nprop)];
        ewp1 = s_des(1:3, 1) + epoint1;
        ewp2 = s_des(1:3, 1) + epoint2;
        ewp3 = s_des(1:3, 1) + epoint3;
        ewp4 = s_des(1:3, 1) + epoint4;
        eprop1 = eproppts + ewp1 * ones(1, nprop);
        eprop2 = eproppts + ewp2 * ones(1, nprop);
        eprop3 = eproppts + ewp3 * ones(1, nprop);
        eprop4 = eproppts + ewp4 * ones(1, nprop);
        emap = [0; 0; 0];
        ewindow = [0; 0; 0];

        if ~vis_init
            thtraj1 = plot3(true_s(1, 1), true_s(2, 1), true_s(3, 1), 'b-', 'LineWidth', 0.5);
            tharm11 = line([twp1(1), twp3(1)], [twp1(2), twp3(2)], [twp1(3), twp3(3)], 'Color', 'b'); %画出无人机交叉臂
            tharm12 = line([twp2(1), twp4(1)], [twp2(2), twp4(2)], [twp2(3), twp4(3)], 'Color', 'b');
            thprop11 = plot3(tprop1(1, :), tprop1(2, :), tprop1(3, :), 'r-'); %画出无人机四个圆圈
            thprop12 = plot3(tprop2(1, :), tprop2(2, :), tprop2(3, :), 'b-');
            thprop13 = plot3(tprop3(1, :), tprop3(2, :), tprop3(3, :), 'b-');
            thprop14 = plot3(tprop4(1, :), tprop4(2, :), tprop4(3, :), 'b-');
            thfov11 = line([tfov0(1), tfov1(1), tfov2(1)], [tfov0(2), tfov1(2), tfov2(2)], [tfov0(3), tfov1(3), tfov2(3)], 'Color', 'k'); 
            thfov12 = line([tfov0(1), tfov2(1), tfov3(1)], [tfov0(2), tfov2(2), tfov3(2)], [tfov0(3), tfov2(3), tfov3(3)], 'Color', 'k');
            thfov13 = line([tfov0(1), tfov3(1), tfov4(1)], [tfov0(2), tfov3(2), tfov4(2)], [tfov0(3), tfov3(3), tfov4(3)], 'Color', 'k');
            thfov14 = line([tfov0(1), tfov4(1), tfov1(1)], [tfov0(2), tfov4(2), tfov1(2)], [tfov0(3), tfov4(3), tfov1(3)], 'Color', 'k');

            ehtraj1 = plot3(s_des(1, 1), s_des(2, 1), s_des(3, 1), 'g-', 'LineWidth', 1);

            eharm11 = line([ewp1(1), ewp3(1)], [ewp1(2), ewp3(2)], [ewp1(3), ewp3(3)], 'Color', 'g');
            eharm12 = line([ewp2(1), ewp4(1)], [ewp2(2), ewp4(2)], [ewp2(3), ewp4(3)], 'Color', 'g');
            ehprop11 = plot3(eprop1(1, :), eprop1(2, :), eprop1(3, :), 'm-');
            ehprop12 = plot3(eprop2(1, :), eprop2(2, :), eprop2(3, :), 'g-');
            ehprop13 = plot3(eprop3(1, :), eprop3(2, :), eprop3(3, :), 'g-');
            ehprop14 = plot3(eprop4(1, :), eprop4(2, :), eprop4(3, :), 'g-');
            ehmap1 = plot3(emap(1, :), emap(2, :), emap(3, :), 'ko', 'MarkerSize', 10, 'MarkerFaceColor', 'k');
            ehwindow1 = plot3(ewindow(1, :), ewindow(2, :), ewindow(3, :), 'ro', 'MarkerSize', 5, 'MarkerFaceColor', 'r');
        else
            set(thtraj1, 'XData', [get(thtraj1, 'XData'), true_s(1, 1)]);
            set(thtraj1, 'YData', [get(thtraj1, 'YData'), true_s(2, 1)]);
            set(thtraj1, 'ZData', [get(thtraj1, 'ZData'), true_s(3, 1)]);
            set(thprop11, 'XData', tprop1(1, :));
            set(thprop11, 'YData', tprop1(2, :));
            set(thprop11, 'ZData', tprop1(3, :));
            set(thprop12, 'XData', tprop2(1, :));
            set(thprop12, 'YData', tprop2(2, :));
            set(thprop12, 'ZData', tprop2(3, :));
            set(thprop13, 'XData', tprop3(1, :));
            set(thprop13, 'YData', tprop3(2, :));
            set(thprop13, 'ZData', tprop3(3, :));
            set(thprop14, 'XData', tprop4(1, :));
            set(thprop14, 'YData', tprop4(2, :));
            set(thprop14, 'ZData', tprop4(3, :));
            set(tharm11, 'XData', [twp1(1), twp3(1)]);
            set(tharm11, 'YData', [twp1(2), twp3(2)]);
            set(tharm11, 'ZData', [twp1(3), twp3(3)]);
            set(tharm12, 'XData', [twp2(1), twp4(1)]);
            set(tharm12, 'YData', [twp2(2), twp4(2)]);
            set(tharm12, 'ZData', [twp2(3), twp4(3)]);
            set(thfov11, 'XData', [tfov0(1), tfov1(1), tfov2(1)]);
            set(thfov11, 'YData', [tfov0(2), tfov1(2), tfov2(2)]);
            set(thfov11, 'ZData', [tfov0(3), tfov1(3), tfov2(3)]);
            set(thfov12, 'XData', [tfov0(1), tfov2(1), tfov3(1)]);
            set(thfov12, 'YData', [tfov0(2), tfov2(2), tfov3(2)]);
            set(thfov12, 'ZData', [tfov0(3), tfov2(3), tfov3(3)]);
            set(thfov13, 'XData', [tfov0(1), tfov3(1), tfov4(1)]);
            set(thfov13, 'YData', [tfov0(2), tfov3(2), tfov4(2)]);
            set(thfov13, 'ZData', [tfov0(3), tfov3(3), tfov4(3)]);
            set(thfov14, 'XData', [tfov0(1), tfov4(1), tfov1(1)]);
            set(thfov14, 'YData', [tfov0(2), tfov4(2), tfov1(2)]);
            set(thfov14, 'ZData', [tfov0(3), tfov4(3), tfov1(3)]);
            set(ehtraj1, 'XData', [get(ehtraj1, 'XData'), s_des(1, 1)]);
            set(ehtraj1, 'YData', [get(ehtraj1, 'YData'), s_des(2, 1)]);
            set(ehtraj1, 'ZData', [get(ehtraj1, 'ZData'), s_des(3, 1)]);
            set(ehprop11, 'XData', eprop1(1, :));
            set(ehprop11, 'YData', eprop1(2, :));
            set(ehprop11, 'ZData', eprop1(3, :));
            set(ehprop12, 'XData', eprop2(1, :));
            set(ehprop12, 'YData', eprop2(2, :));
            set(ehprop12, 'ZData', eprop2(3, :));
            set(ehprop13, 'XData', eprop3(1, :));
            set(ehprop13, 'YData', eprop3(2, :));
            set(ehprop13, 'ZData', eprop3(3, :));
            set(ehprop14, 'XData', eprop4(1, :));
            set(ehprop14, 'YData', eprop4(2, :));
            set(ehprop14, 'ZData', eprop4(3, :));
            set(eharm11, 'XData', [ewp1(1), ewp3(1)]);
            set(eharm11, 'YData', [ewp1(2), ewp3(2)]);
            set(eharm11, 'ZData', [ewp1(3), ewp3(3)]);
            set(eharm12, 'XData', [ewp2(1), ewp4(1)]);
            set(eharm12, 'YData', [ewp2(2), ewp4(2)]);
            set(eharm12, 'ZData', [ewp2(3), ewp4(3)]);
            set(ehmap1, 'XData', emap(1, :));
            set(ehmap1, 'YData', emap(2, :));
            set(ehmap1, 'ZData', emap(3, :));
            set(ehwindow1, 'XData', ewindow(1, :));
            set(ehwindow1, 'YData', ewindow(2, :));
            set(ehwindow1, 'ZData', ewindow(3, :));
        end
        hold on;

        grid on;


        twp1 = true_s(1:3, 2) + tpoint1;
        twp2 = true_s(1:3, 2) + tpoint2;
        twp3 = true_s(1:3, 2) + tpoint3;
        twp4 = true_s(1:3, 2) + tpoint4;
        tprop1 = tproppts + twp1 * ones(1, nprop);
        tprop2 = tproppts + twp2 * ones(1, nprop);
        tprop3 = tproppts + twp3 * ones(1, nprop);
        tprop4 = tproppts + twp4 * ones(1, nprop);
        tfov0 = true_s(1:3, 2);
        tfov1 = tR * [ff; ff * tan(ifov*pi/180/2); ff * tan(ifov*pi/180/2)] + true_s(1:3, 2);
        tfov2 = tR * [ff; ff * tan(ifov*pi/180/2); -ff * tan(ifov*pi/180/2)] + true_s(1:3, 2);
        tfov3 = tR * [ff; -ff * tan(ifov*pi/180/2); -ff * tan(ifov*pi/180/2)] + true_s(1:3, 2);
        tfov4 = tR * [ff; -ff * tan(ifov*pi/180/2); ff * tan(ifov*pi/180/2)] + true_s(1:3, 2);
        eR = QuatToRot(s_des(7:10, 2))';
        epoint1 = eR * [ll; 0; 0];
        epoint2 = eR * [0; ll; 0];
        epoint3 = eR * [-ll; 0; 0];
        epoint4 = eR * [0; -ll; 0];
        eproppts = rr * eR * [cos(propangs); sin(propangs); zeros(1, nprop)];


        ewp1 = s_des(1:3, 2) + epoint1;
        ewp2 = s_des(1:3, 2) + epoint2;
        ewp3 = s_des(1:3, 2) + epoint3;
        ewp4 = s_des(1:3, 2) + epoint4;

        eprop1 = eproppts + ewp1 * ones(1, nprop);
        eprop2 = eproppts + ewp2 * ones(1, nprop);
        eprop3 = eproppts + ewp3 * ones(1, nprop);
        eprop4 = eproppts + ewp4 * ones(1, nprop);
        emap = [0; 0; 0];
        ewindow = [0; 0; 0];

        if ~vis_init
            thtraj2 = plot3(true_s(1, 2), true_s(2, 2), true_s(3, 2), 'b-', 'LineWidth', 0.5);
            tharm21 = line([twp1(1), twp3(1)], [twp1(2), twp3(2)], [twp1(3), twp3(3)], 'Color', 'b');
            tharm22 = line([twp2(1), twp4(1)], [twp2(2), twp4(2)], [twp2(3), twp4(3)], 'Color', 'b');
            thprop21 = plot3(tprop1(1, :), tprop1(2, :), tprop1(3, :), 'r-');
            thprop22 = plot3(tprop2(1, :), tprop2(2, :), tprop2(3, :), 'b-');
            thprop23 = plot3(tprop3(1, :), tprop3(2, :), tprop3(3, :), 'b-');
            thprop24 = plot3(tprop4(1, :), tprop4(2, :), tprop4(3, :), 'b-');
            thfov21 = line([tfov0(1), tfov1(1), tfov2(1)], [tfov0(2), tfov1(2), tfov2(2)], [tfov0(3), tfov1(3), tfov2(3)], 'Color', 'k');
            thfov22 = line([tfov0(1), tfov2(1), tfov3(1)], [tfov0(2), tfov2(2), tfov3(2)], [tfov0(3), tfov2(3), tfov3(3)], 'Color', 'k');
            thfov23 = line([tfov0(1), tfov3(1), tfov4(1)], [tfov0(2), tfov3(2), tfov4(2)], [tfov0(3), tfov3(3), tfov4(3)], 'Color', 'k');
            thfov24 = line([tfov0(1), tfov4(1), tfov1(1)], [tfov0(2), tfov4(2), tfov1(2)], [tfov0(3), tfov4(3), tfov1(3)], 'Color', 'k');

            ehtraj2 = plot3(s_des(1, 2), s_des(2, 2), s_des(3, 2), 'g-', 'LineWidth', 1);

            eharm21 = line([ewp1(1), ewp3(1)], [ewp1(2), ewp3(2)], [ewp1(3), ewp3(3)], 'Color', 'g');
            eharm22 = line([ewp2(1), ewp4(1)], [ewp2(2), ewp4(2)], [ewp2(3), ewp4(3)], 'Color', 'g');
            ehprop21 = plot3(eprop1(1, :), eprop1(2, :), eprop1(3, :), 'm-');
            ehprop22 = plot3(eprop2(1, :), eprop2(2, :), eprop2(3, :), 'g-');
            ehprop23 = plot3(eprop3(1, :), eprop3(2, :), eprop3(3, :), 'g-');
            ehprop24 = plot3(eprop4(1, :), eprop4(2, :), eprop4(3, :), 'g-');
            ehmap2 = plot3(emap(1, :), emap(2, :), emap(3, :), 'ko', 'MarkerSize', 10, 'MarkerFaceColor', 'k');
            ehwindow2 = plot3(ewindow(1, :), ewindow(2, :), ewindow(3, :), 'ro', 'MarkerSize', 5, 'MarkerFaceColor', 'r');
        else
            set(thtraj2, 'XData', [get(thtraj2, 'XData'), true_s(1, 2)]);
            set(thtraj2, 'YData', [get(thtraj2, 'YData'), true_s(2, 2)]);
            set(thtraj2, 'ZData', [get(thtraj2, 'ZData'), true_s(3, 2)]);
            set(thprop21, 'XData', tprop1(1, :));
            set(thprop21, 'YData', tprop1(2, :));
            set(thprop21, 'ZData', tprop1(3, :));
            set(thprop22, 'XData', tprop2(1, :));
            set(thprop22, 'YData', tprop2(2, :));
            set(thprop22, 'ZData', tprop2(3, :));
            set(thprop23, 'XData', tprop3(1, :));
            set(thprop23, 'YData', tprop3(2, :));
            set(thprop23, 'ZData', tprop3(3, :));
            set(thprop24, 'XData', tprop4(1, :));
            set(thprop24, 'YData', tprop4(2, :));
            set(thprop24, 'ZData', tprop4(3, :));
            set(tharm21, 'XData', [twp1(1), twp3(1)]);
            set(tharm21, 'YData', [twp1(2), twp3(2)]);
            set(tharm21, 'ZData', [twp1(3), twp3(3)]);
            set(tharm22, 'XData', [twp2(1), twp4(1)]);
            set(tharm22, 'YData', [twp2(2), twp4(2)]);
            set(tharm22, 'ZData', [twp2(3), twp4(3)]);
            set(thfov21, 'XData', [tfov0(1), tfov1(1), tfov2(1)]);
            set(thfov21, 'YData', [tfov0(2), tfov1(2), tfov2(2)]);
            set(thfov21, 'ZData', [tfov0(3), tfov1(3), tfov2(3)]);
            set(thfov22, 'XData', [tfov0(1), tfov2(1), tfov3(1)]);
            set(thfov22, 'YData', [tfov0(2), tfov2(2), tfov3(2)]);
            set(thfov22, 'ZData', [tfov0(3), tfov2(3), tfov3(3)]);
            set(thfov23, 'XData', [tfov0(1), tfov3(1), tfov4(1)]);
            set(thfov23, 'YData', [tfov0(2), tfov3(2), tfov4(2)]);
            set(thfov23, 'ZData', [tfov0(3), tfov3(3), tfov4(3)]);
            set(thfov24, 'XData', [tfov0(1), tfov4(1), tfov1(1)]);
            set(thfov24, 'YData', [tfov0(2), tfov4(2), tfov1(2)]);
            set(thfov24, 'ZData', [tfov0(3), tfov4(3), tfov1(3)]);
            set(ehtraj2, 'XData', [get(ehtraj2, 'XData'), s_des(1, 2)]);
            set(ehtraj2, 'YData', [get(ehtraj2, 'YData'), s_des(2, 2)]);
            set(ehtraj2, 'ZData', [get(ehtraj2, 'ZData'), s_des(3, 2)]);
            set(ehprop21, 'XData', eprop1(1, :));
            set(ehprop21, 'YData', eprop1(2, :));
            set(ehprop21, 'ZData', eprop1(3, :));
            set(ehprop22, 'XData', eprop2(1, :));
            set(ehprop22, 'YData', eprop2(2, :));
            set(ehprop22, 'ZData', eprop2(3, :));
            set(ehprop23, 'XData', eprop3(1, :));
            set(ehprop23, 'YData', eprop3(2, :));
            set(ehprop23, 'ZData', eprop3(3, :));
            set(ehprop24, 'XData', eprop4(1, :));
            set(ehprop24, 'YData', eprop4(2, :));
            set(ehprop24, 'ZData', eprop4(3, :));
            set(eharm21, 'XData', [ewp1(1), ewp3(1)]);
            set(eharm21, 'YData', [ewp1(2), ewp3(2)]);
            set(eharm21, 'ZData', [ewp1(3), ewp3(3)]);
            set(eharm22, 'XData', [ewp2(1), ewp4(1)]);
            set(eharm22, 'YData', [ewp2(2), ewp4(2)]);
            set(eharm22, 'ZData', [ewp2(3), ewp4(3)]);
            set(ehmap2, 'XData', emap(1, :));
            set(ehmap2, 'YData', emap(2, :));
            set(ehmap2, 'ZData', emap(3, :));
            set(ehwindow2, 'XData', ewindow(1, :));
            set(ehwindow2, 'YData', ewindow(2, :));
            set(ehwindow2, 'ZData', ewindow(3, :));
        end

        hold on;

        grid on;


        twp1 = true_s(1:3, 3) + tpoint1;
        twp2 = true_s(1:3, 3) + tpoint2;
        twp3 = true_s(1:3, 3) + tpoint3;
        twp4 = true_s(1:3, 3) + tpoint4;
        tprop1 = tproppts + twp1 * ones(1, nprop);
        tprop2 = tproppts + twp2 * ones(1, nprop);
        tprop3 = tproppts + twp3 * ones(1, nprop);
        tprop4 = tproppts + twp4 * ones(1, nprop);
        tfov0 = true_s(1:3, 3);
        tfov1 = tR * [ff; ff * tan(ifov*pi/180/2); ff * tan(ifov*pi/180/2)] + true_s(1:3, 3);
        tfov2 = tR * [ff; ff * tan(ifov*pi/180/2); -ff * tan(ifov*pi/180/2)] + true_s(1:3, 3);
        tfov3 = tR * [ff; -ff * tan(ifov*pi/180/2); -ff * tan(ifov*pi/180/2)] + true_s(1:3, 3);
        tfov4 = tR * [ff; -ff * tan(ifov*pi/180/2); ff * tan(ifov*pi/180/2)] + true_s(1:3, 3);
        eR = QuatToRot(s_des(7:10, 3))';
        epoint1 = eR * [ll; 0; 0];
        epoint2 = eR * [0; ll; 0];
        epoint3 = eR * [-ll; 0; 0];
        epoint4 = eR * [0; -ll; 0];
        eproppts = rr * eR * [cos(propangs); sin(propangs); zeros(1, nprop)];


        ewp1 = s_des(1:3, 3) + epoint1;
        ewp2 = s_des(1:3, 3) + epoint2;
        ewp3 = s_des(1:3, 3) + epoint3;
        ewp4 = s_des(1:3, 3) + epoint4;

        eprop1 = eproppts + ewp1 * ones(1, nprop);
        eprop2 = eproppts + ewp2 * ones(1, nprop);
        eprop3 = eproppts + ewp3 * ones(1, nprop);
        eprop4 = eproppts + ewp4 * ones(1, nprop);
        emap = [0; 0; 0];
        ewindow = [0; 0; 0];

        if ~vis_init
            thtraj3 = plot3(true_s(1, 3), true_s(2, 3), true_s(3, 3), 'b-', 'LineWidth', 0.5);
            tharm31 = line([twp1(1), twp3(1)], [twp1(2), twp3(2)], [twp1(3), twp3(3)], 'Color', 'b');
            tharm32 = line([twp2(1), twp4(1)], [twp2(2), twp4(2)], [twp2(3), twp4(3)], 'Color', 'b');
            thprop31 = plot3(tprop1(1, :), tprop1(2, :), tprop1(3, :), 'r-');
            thprop32 = plot3(tprop2(1, :), tprop2(2, :), tprop2(3, :), 'b-');
            thprop33 = plot3(tprop3(1, :), tprop3(2, :), tprop3(3, :), 'b-');
            thprop34 = plot3(tprop4(1, :), tprop4(2, :), tprop4(3, :), 'b-');
            thfov31 = line([tfov0(1), tfov1(1), tfov2(1)], [tfov0(2), tfov1(2), tfov2(2)], [tfov0(3), tfov1(3), tfov2(3)], 'Color', 'k');
            thfov32 = line([tfov0(1), tfov2(1), tfov3(1)], [tfov0(2), tfov2(2), tfov3(2)], [tfov0(3), tfov2(3), tfov3(3)], 'Color', 'k');
            thfov33 = line([tfov0(1), tfov3(1), tfov4(1)], [tfov0(2), tfov3(2), tfov4(2)], [tfov0(3), tfov3(3), tfov4(3)], 'Color', 'k');
            thfov34 = line([tfov0(1), tfov4(1), tfov1(1)], [tfov0(2), tfov4(2), tfov1(2)], [tfov0(3), tfov4(3), tfov1(3)], 'Color', 'k');

            ehtraj3 = plot3(s_des(1, 3), s_des(2, 3), s_des(3, 3), 'g-', 'LineWidth', 0.5);

            eharm31 = line([ewp1(1), ewp3(1)], [ewp1(2), ewp3(2)], [ewp1(3), ewp3(3)], 'Color', 'g');
            eharm32 = line([ewp2(1), ewp4(1)], [ewp2(2), ewp4(2)], [ewp2(3), ewp4(3)], 'Color', 'g');
            ehprop31 = plot3(eprop1(1, :), eprop1(2, :), eprop1(3, :), 'm-');
            ehprop32 = plot3(eprop2(1, :), eprop2(2, :), eprop2(3, :), 'g-');
            ehprop33 = plot3(eprop3(1, :), eprop3(2, :), eprop3(3, :), 'g-');
            ehprop34 = plot3(eprop4(1, :), eprop4(2, :), eprop4(3, :), 'g-');
            ehmap3 = plot3(emap(1, :), emap(2, :), emap(3, :), 'ko', 'MarkerSize', 10, 'MarkerFaceColor', 'k');
            ehwindow3 = plot3(ewindow(1, :), ewindow(2, :), ewindow(3, :), 'ro', 'MarkerSize', 5, 'MarkerFaceColor', 'r');
        else
            set(thtraj3, 'XData', [get(thtraj3, 'XData'), true_s(1, 3)]);
            set(thtraj3, 'YData', [get(thtraj3, 'YData'), true_s(2, 3)]);
            set(thtraj3, 'ZData', [get(thtraj3, 'ZData'), true_s(3, 3)]);
            set(thprop31, 'XData', tprop1(1, :));
            set(thprop31, 'YData', tprop1(2, :));
            set(thprop31, 'ZData', tprop1(3, :));
            set(thprop32, 'XData', tprop2(1, :));
            set(thprop32, 'YData', tprop2(2, :));
            set(thprop32, 'ZData', tprop2(3, :));
            set(thprop33, 'XData', tprop3(1, :));
            set(thprop33, 'YData', tprop3(2, :));
            set(thprop33, 'ZData', tprop3(3, :));
            set(thprop34, 'XData', tprop4(1, :));
            set(thprop34, 'YData', tprop4(2, :));
            set(thprop34, 'ZData', tprop4(3, :));
            set(tharm31, 'XData', [twp1(1), twp3(1)]);
            set(tharm31, 'YData', [twp1(2), twp3(2)]);
            set(tharm31, 'ZData', [twp1(3), twp3(3)]);
            set(tharm32, 'XData', [twp2(1), twp4(1)]);
            set(tharm32, 'YData', [twp2(2), twp4(2)]);
            set(tharm32, 'ZData', [twp2(3), twp4(3)]);
            set(thfov31, 'XData', [tfov0(1), tfov1(1), tfov2(1)]);
            set(thfov31, 'YData', [tfov0(2), tfov1(2), tfov2(2)]);
            set(thfov31, 'ZData', [tfov0(3), tfov1(3), tfov2(3)]);
            set(thfov32, 'XData', [tfov0(1), tfov2(1), tfov3(1)]);
            set(thfov32, 'YData', [tfov0(2), tfov2(2), tfov3(2)]);
            set(thfov32, 'ZData', [tfov0(3), tfov2(3), tfov3(3)]);
            set(thfov33, 'XData', [tfov0(1), tfov3(1), tfov4(1)]);
            set(thfov33, 'YData', [tfov0(2), tfov3(2), tfov4(2)]);
            set(thfov33, 'ZData', [tfov0(3), tfov3(3), tfov4(3)]);
            set(thfov34, 'XData', [tfov0(1), tfov4(1), tfov1(1)]);
            set(thfov34, 'YData', [tfov0(2), tfov4(2), tfov1(2)]);
            set(thfov34, 'ZData', [tfov0(3), tfov4(3), tfov1(3)]);
            set(ehtraj3, 'XData', [get(ehtraj3, 'XData'), s_des(1, 3)]);
            set(ehtraj3, 'YData', [get(ehtraj3, 'YData'), s_des(2, 3)]);
            set(ehtraj3, 'ZData', [get(ehtraj3, 'ZData'), s_des(3, 3)]);
            set(ehprop31, 'XData', eprop1(1, :));
            set(ehprop31, 'YData', eprop1(2, :));
            set(ehprop31, 'ZData', eprop1(3, :));
            set(ehprop32, 'XData', eprop2(1, :));
            set(ehprop32, 'YData', eprop2(2, :));
            set(ehprop32, 'ZData', eprop2(3, :));
            set(ehprop33, 'XData', eprop3(1, :));
            set(ehprop33, 'YData', eprop3(2, :));
            set(ehprop33, 'ZData', eprop3(3, :));
            set(ehprop34, 'XData', eprop4(1, :));
            set(ehprop34, 'YData', eprop4(2, :));
            set(ehprop34, 'ZData', eprop4(3, :));
            set(eharm31, 'XData', [ewp1(1), ewp3(1)]);
            set(eharm31, 'YData', [ewp1(2), ewp3(2)]);
            set(eharm31, 'ZData', [ewp1(3), ewp3(3)]);
            set(eharm32, 'XData', [ewp2(1), ewp4(1)]);
            set(eharm32, 'YData', [ewp2(2), ewp4(2)]);
            set(eharm32, 'ZData', [ewp2(3), ewp4(3)]);
            set(ehmap3, 'XData', emap(1, :));
            set(ehmap3, 'YData', emap(2, :));
            set(ehmap3, 'ZData', emap(3, :));
            set(ehwindow3, 'XData', ewindow(1, :));
            set(ehwindow3, 'YData', ewindow(2, :));
            set(ehwindow3, 'ZData', ewindow(3, :));
        end

        hold on;

        grid on;


        twp1 = true_s(1:3, 4) + tpoint1;
        twp2 = true_s(1:3, 4) + tpoint2;
        twp3 = true_s(1:3, 4) + tpoint3;
        twp4 = true_s(1:3, 4) + tpoint4;
        tprop1 = tproppts + twp1 * ones(1, nprop);
        tprop2 = tproppts + twp2 * ones(1, nprop);
        tprop3 = tproppts + twp3 * ones(1, nprop);
        tprop4 = tproppts + twp4 * ones(1, nprop);
        tfov0 = true_s(1:3, 4);
        tfov1 = tR * [ff; ff * tan(ifov*pi/180/2); ff * tan(ifov*pi/180/2)] + true_s(1:3, 4);
        tfov2 = tR * [ff; ff * tan(ifov*pi/180/2); -ff * tan(ifov*pi/180/2)] + true_s(1:3, 4);
        tfov3 = tR * [ff; -ff * tan(ifov*pi/180/2); -ff * tan(ifov*pi/180/2)] + true_s(1:3, 4);
        tfov4 = tR * [ff; -ff * tan(ifov*pi/180/2); ff * tan(ifov*pi/180/2)] + true_s(1:3, 4);
        eR = QuatToRot(s_des(7:10, 4))';
        epoint1 = eR * [ll; 0; 0];
        epoint2 = eR * [0; ll; 0];
        epoint3 = eR * [-ll; 0; 0];
        epoint4 = eR * [0; -ll; 0];
        eproppts = rr * eR * [cos(propangs); sin(propangs); zeros(1, nprop)];


        ewp1 = s_des(1:3, 4) + epoint1;
        ewp2 = s_des(1:3, 4) + epoint2;
        ewp3 = s_des(1:3, 4) + epoint3;
        ewp4 = s_des(1:3, 4) + epoint4;

        eprop1 = eproppts + ewp1 * ones(1, nprop);
        eprop2 = eproppts + ewp2 * ones(1, nprop);
        eprop3 = eproppts + ewp3 * ones(1, nprop);
        eprop4 = eproppts + ewp4 * ones(1, nprop);
        emap = [0; 0; 0];
        ewindow = [0; 0; 0];

        if ~vis_init
            thtraj4 = plot3(true_s(1, 4), true_s(2, 4), true_s(3, 4), 'b-', 'LineWidth', 0.5);
            tharm41 = line([twp1(1), twp3(1)], [twp1(2), twp3(2)], [twp1(3), twp3(3)], 'Color', 'b');
            tharm42 = line([twp2(1), twp4(1)], [twp2(2), twp4(2)], [twp2(3), twp4(3)], 'Color', 'b');
            thprop41 = plot3(tprop1(1, :), tprop1(2, :), tprop1(3, :), 'r-');
            thprop42 = plot3(tprop2(1, :), tprop2(2, :), tprop2(3, :), 'b-');
            thprop43 = plot3(tprop3(1, :), tprop3(2, :), tprop3(3, :), 'b-');
            thprop44 = plot3(tprop4(1, :), tprop4(2, :), tprop4(3, :), 'b-');
            thfov41 = line([tfov0(1), tfov1(1), tfov2(1)], [tfov0(2), tfov1(2), tfov2(2)], [tfov0(3), tfov1(3), tfov2(3)], 'Color', 'k');
            thfov42 = line([tfov0(1), tfov2(1), tfov3(1)], [tfov0(2), tfov2(2), tfov3(2)], [tfov0(3), tfov2(3), tfov3(3)], 'Color', 'k');
            thfov43 = line([tfov0(1), tfov3(1), tfov4(1)], [tfov0(2), tfov3(2), tfov4(2)], [tfov0(3), tfov3(3), tfov4(3)], 'Color', 'k');
            thfov44 = line([tfov0(1), tfov4(1), tfov1(1)], [tfov0(2), tfov4(2), tfov1(2)], [tfov0(3), tfov4(3), tfov1(3)], 'Color', 'k');

            ehtraj4 = plot3(s_des(1, 4), s_des(2, 4), s_des(3, 4), 'g-', 'LineWidth', 0.5);

            eharm41 = line([ewp1(1), ewp3(1)], [ewp1(2), ewp3(2)], [ewp1(3), ewp3(3)], 'Color', 'g');
            eharm42 = line([ewp2(1), ewp4(1)], [ewp2(2), ewp4(2)], [ewp2(3), ewp4(3)], 'Color', 'g');
            ehprop41 = plot3(eprop1(1, :), eprop1(2, :), eprop1(3, :), 'm-');
            ehprop42 = plot3(eprop2(1, :), eprop2(2, :), eprop2(3, :), 'g-');
            ehprop43 = plot3(eprop3(1, :), eprop3(2, :), eprop3(3, :), 'g-');
            ehprop44 = plot3(eprop4(1, :), eprop4(2, :), eprop4(3, :), 'g-');
            ehmap4 = plot3(emap(1, :), emap(2, :), emap(3, :), 'ko', 'MarkerSize', 10, 'MarkerFaceColor', 'k');
            ehwindow4 = plot3(ewindow(1, :), ewindow(2, :), ewindow(3, :), 'ro', 'MarkerSize', 5, 'MarkerFaceColor', 'r');
        else
            set(thtraj4, 'XData', [get(thtraj4, 'XData'), true_s(1, 4)]);
            set(thtraj4, 'YData', [get(thtraj4, 'YData'), true_s(2, 4)]);
            set(thtraj4, 'ZData', [get(thtraj4, 'ZData'), true_s(3, 4)]);
            set(thprop41, 'XData', tprop1(1, :));
            set(thprop41, 'YData', tprop1(2, :));
            set(thprop41, 'ZData', tprop1(3, :));
            set(thprop42, 'XData', tprop2(1, :));
            set(thprop42, 'YData', tprop2(2, :));
            set(thprop42, 'ZData', tprop2(3, :));
            set(thprop43, 'XData', tprop3(1, :));
            set(thprop43, 'YData', tprop3(2, :));
            set(thprop43, 'ZData', tprop3(3, :));
            set(thprop44, 'XData', tprop4(1, :));
            set(thprop44, 'YData', tprop4(2, :));
            set(thprop44, 'ZData', tprop4(3, :));
            set(tharm41, 'XData', [twp1(1), twp3(1)]);
            set(tharm41, 'YData', [twp1(2), twp3(2)]);
            set(tharm41, 'ZData', [twp1(3), twp3(3)]);
            set(tharm42, 'XData', [twp2(1), twp4(1)]);
            set(tharm42, 'YData', [twp2(2), twp4(2)]);
            set(tharm42, 'ZData', [twp2(3), twp4(3)]);
            set(thfov41, 'XData', [tfov0(1), tfov1(1), tfov2(1)]);
            set(thfov41, 'YData', [tfov0(2), tfov1(2), tfov2(2)]);
            set(thfov41, 'ZData', [tfov0(3), tfov1(3), tfov2(3)]);
            set(thfov42, 'XData', [tfov0(1), tfov2(1), tfov3(1)]);
            set(thfov42, 'YData', [tfov0(2), tfov2(2), tfov3(2)]);
            set(thfov42, 'ZData', [tfov0(3), tfov2(3), tfov3(3)]);
            set(thfov43, 'XData', [tfov0(1), tfov3(1), tfov4(1)]);
            set(thfov43, 'YData', [tfov0(2), tfov3(2), tfov4(2)]);
            set(thfov43, 'ZData', [tfov0(3), tfov3(3), tfov4(3)]);
            set(thfov44, 'XData', [tfov0(1), tfov4(1), tfov1(1)]);
            set(thfov44, 'YData', [tfov0(2), tfov4(2), tfov1(2)]);
            set(thfov44, 'ZData', [tfov0(3), tfov4(3), tfov1(3)]);
            set(ehtraj4, 'XData', [get(ehtraj4, 'XData'), s_des(1, 4)]);
            set(ehtraj4, 'YData', [get(ehtraj4, 'YData'), s_des(2, 4)]);
            set(ehtraj4, 'ZData', [get(ehtraj4, 'ZData'), s_des(3, 4)]);
            set(ehprop41, 'XData', eprop1(1, :));
            set(ehprop41, 'YData', eprop1(2, :));
            set(ehprop41, 'ZData', eprop1(3, :));
            set(ehprop42, 'XData', eprop2(1, :));
            set(ehprop42, 'YData', eprop2(2, :));
            set(ehprop42, 'ZData', eprop2(3, :));
            set(ehprop43, 'XData', eprop3(1, :));
            set(ehprop43, 'YData', eprop3(2, :));
            set(ehprop43, 'ZData', eprop3(3, :));
            set(ehprop44, 'XData', eprop4(1, :));
            set(ehprop44, 'YData', eprop4(2, :));
            set(ehprop44, 'ZData', eprop4(3, :));
            set(eharm41, 'XData', [ewp1(1), ewp3(1)]);
            set(eharm41, 'YData', [ewp1(2), ewp3(2)]);
            set(eharm41, 'ZData', [ewp1(3), ewp3(3)]);
            set(eharm42, 'XData', [ewp2(1), ewp4(1)]);
            set(eharm42, 'YData', [ewp2(2), ewp4(2)]);
            set(eharm42, 'ZData', [ewp2(3), ewp4(3)]);
            set(ehmap4, 'XData', emap(1, :));
            set(ehmap4, 'YData', emap(2, :));
            set(ehmap4, 'ZData', emap(3, :));
            set(ehwindow4, 'XData', ewindow(1, :));
            set(ehwindow4, 'YData', ewindow(2, :));
            set(ehwindow4, 'ZData', ewindow(3, :));
        end


        hold on;

        grid on;


        twp1 = true_s(1:3, 5) + tpoint1;
        twp2 = true_s(1:3, 5) + tpoint2;
        twp3 = true_s(1:3, 5) + tpoint3;
        twp4 = true_s(1:3, 5) + tpoint4;
        tprop1 = tproppts + twp1 * ones(1, nprop);
        tprop2 = tproppts + twp2 * ones(1, nprop);
        tprop3 = tproppts + twp3 * ones(1, nprop);
        tprop4 = tproppts + twp4 * ones(1, nprop);
        tfov0 = true_s(1:3, 5);
        tfov1 = tR * [ff; ff * tan(ifov*pi/180/2); ff * tan(ifov*pi/180/2)] + true_s(1:3, 5);
        tfov2 = tR * [ff; ff * tan(ifov*pi/180/2); -ff * tan(ifov*pi/180/2)] + true_s(1:3, 5);
        tfov3 = tR * [ff; -ff * tan(ifov*pi/180/2); -ff * tan(ifov*pi/180/2)] + true_s(1:3, 5);
        tfov4 = tR * [ff; -ff * tan(ifov*pi/180/2); ff * tan(ifov*pi/180/2)] + true_s(1:3, 5);
        eR = QuatToRot(s_des(7:10, 5))';
        epoint1 = eR * [ll; 0; 0];
        epoint2 = eR * [0; ll; 0];
        epoint3 = eR * [-ll; 0; 0];
        epoint4 = eR * [0; -ll; 0];
        eproppts = rr * eR * [cos(propangs); sin(propangs); zeros(1, nprop)];


        ewp1 = s_des(1:3, 5) + epoint1;
        ewp2 = s_des(1:3, 5) + epoint2;
        ewp3 = s_des(1:3, 5) + epoint3;
        ewp4 = s_des(1:3, 5) + epoint4;

        eprop1 = eproppts + ewp1 * ones(1, nprop);
        eprop2 = eproppts + ewp2 * ones(1, nprop);
        eprop3 = eproppts + ewp3 * ones(1, nprop);
        eprop4 = eproppts + ewp4 * ones(1, nprop);
        emap = [0; 0; 0];
        ewindow = [0; 0; 0];

        if ~vis_init
            thtraj5 = plot3(true_s(1, 5), true_s(2, 5), true_s(3, 5), 'b-', 'LineWidth', 0.5);
            tharm51 = line([twp1(1), twp3(1)], [twp1(2), twp3(2)], [twp1(3), twp3(3)], 'Color', 'b');
            tharm52 = line([twp2(1), twp4(1)], [twp2(2), twp4(2)], [twp2(3), twp4(3)], 'Color', 'b');
            thprop51 = plot3(tprop1(1, :), tprop1(2, :), tprop1(3, :), 'r-');
            thprop52 = plot3(tprop2(1, :), tprop2(2, :), tprop2(3, :), 'b-');
            thprop53 = plot3(tprop3(1, :), tprop3(2, :), tprop3(3, :), 'b-');
            thprop54 = plot3(tprop4(1, :), tprop4(2, :), tprop4(3, :), 'b-');
            thfov51 = line([tfov0(1), tfov1(1), tfov2(1)], [tfov0(2), tfov1(2), tfov2(2)], [tfov0(3), tfov1(3), tfov2(3)], 'Color', 'k');
            thfov52 = line([tfov0(1), tfov2(1), tfov3(1)], [tfov0(2), tfov2(2), tfov3(2)], [tfov0(3), tfov2(3), tfov3(3)], 'Color', 'k');
            thfov53 = line([tfov0(1), tfov3(1), tfov4(1)], [tfov0(2), tfov3(2), tfov4(2)], [tfov0(3), tfov3(3), tfov4(3)], 'Color', 'k');
            thfov54 = line([tfov0(1), tfov4(1), tfov1(1)], [tfov0(2), tfov4(2), tfov1(2)], [tfov0(3), tfov4(3), tfov1(3)], 'Color', 'k');

            ehtraj5 = plot3(s_des(1, 5), s_des(2, 5), s_des(3, 5), 'g-', 'LineWidth', 0.5);

            eharm51 = line([ewp1(1), ewp3(1)], [ewp1(2), ewp3(2)], [ewp1(3), ewp3(3)], 'Color', 'g');
            eharm52 = line([ewp2(1), ewp4(1)], [ewp2(2), ewp4(2)], [ewp2(3), ewp4(3)], 'Color', 'g');
            ehprop51 = plot3(eprop1(1, :), eprop1(2, :), eprop1(3, :), 'm-');
            ehprop52 = plot3(eprop2(1, :), eprop2(2, :), eprop2(3, :), 'g-');
            ehprop53 = plot3(eprop3(1, :), eprop3(2, :), eprop3(3, :), 'g-');
            ehprop54 = plot3(eprop4(1, :), eprop4(2, :), eprop4(3, :), 'g-');
            ehmap5 = plot3(emap(1, :), emap(2, :), emap(3, :), 'ko', 'MarkerSize', 10, 'MarkerFaceColor', 'k');
            ehwindow5 = plot3(ewindow(1, :), ewindow(2, :), ewindow(3, :), 'ro', 'MarkerSize', 5, 'MarkerFaceColor', 'r');
        else
            set(thtraj5, 'XData', [get(thtraj5, 'XData'), true_s(1, 5)]);
            set(thtraj5, 'YData', [get(thtraj5, 'YData'), true_s(2, 5)]);
            set(thtraj5, 'ZData', [get(thtraj5, 'ZData'), true_s(3, 5)]);
            set(thprop51, 'XData', tprop1(1, :));
            set(thprop51, 'YData', tprop1(2, :));
            set(thprop51, 'ZData', tprop1(3, :));
            set(thprop52, 'XData', tprop2(1, :));
            set(thprop52, 'YData', tprop2(2, :));
            set(thprop52, 'ZData', tprop2(3, :));
            set(thprop53, 'XData', tprop3(1, :));
            set(thprop53, 'YData', tprop3(2, :));
            set(thprop53, 'ZData', tprop3(3, :));
            set(thprop54, 'XData', tprop4(1, :));
            set(thprop54, 'YData', tprop4(2, :));
            set(thprop54, 'ZData', tprop4(3, :));
            set(tharm51, 'XData', [twp1(1), twp3(1)]);
            set(tharm51, 'YData', [twp1(2), twp3(2)]);
            set(tharm51, 'ZData', [twp1(3), twp3(3)]);
            set(tharm52, 'XData', [twp2(1), twp4(1)]);
            set(tharm52, 'YData', [twp2(2), twp4(2)]);
            set(tharm52, 'ZData', [twp2(3), twp4(3)]);
            set(thfov51, 'XData', [tfov0(1), tfov1(1), tfov2(1)]);
            set(thfov51, 'YData', [tfov0(2), tfov1(2), tfov2(2)]);
            set(thfov51, 'ZData', [tfov0(3), tfov1(3), tfov2(3)]);
            set(thfov52, 'XData', [tfov0(1), tfov2(1), tfov3(1)]);
            set(thfov52, 'YData', [tfov0(2), tfov2(2), tfov3(2)]);
            set(thfov52, 'ZData', [tfov0(3), tfov2(3), tfov3(3)]);
            set(thfov53, 'XData', [tfov0(1), tfov3(1), tfov4(1)]);
            set(thfov53, 'YData', [tfov0(2), tfov3(2), tfov4(2)]);
            set(thfov53, 'ZData', [tfov0(3), tfov3(3), tfov4(3)]);
            set(thfov54, 'XData', [tfov0(1), tfov4(1), tfov1(1)]);
            set(thfov54, 'YData', [tfov0(2), tfov4(2), tfov1(2)]);
            set(thfov54, 'ZData', [tfov0(3), tfov4(3), tfov1(3)]);
            set(ehtraj5, 'XData', [get(ehtraj5, 'XData'), s_des(1, 5)]);
            set(ehtraj5, 'YData', [get(ehtraj5, 'YData'), s_des(2, 5)]);
            set(ehtraj5, 'ZData', [get(ehtraj5, 'ZData'), s_des(3, 5)]);
            set(ehprop51, 'XData', eprop1(1, :));
            set(ehprop51, 'YData', eprop1(2, :));
            set(ehprop51, 'ZData', eprop1(3, :));
            set(ehprop52, 'XData', eprop2(1, :));
            set(ehprop52, 'YData', eprop2(2, :));
            set(ehprop52, 'ZData', eprop2(3, :));
            set(ehprop53, 'XData', eprop3(1, :));
            set(ehprop53, 'YData', eprop3(2, :));
            set(ehprop53, 'ZData', eprop3(3, :));
            set(ehprop54, 'XData', eprop4(1, :));
            set(ehprop54, 'YData', eprop4(2, :));
            set(ehprop54, 'ZData', eprop4(3, :));
            set(eharm51, 'XData', [ewp1(1), ewp3(1)]);
            set(eharm51, 'YData', [ewp1(2), ewp3(2)]);
            set(eharm51, 'ZData', [ewp1(3), ewp3(3)]);
            set(eharm52, 'XData', [ewp2(1), ewp4(1)]);
            set(eharm52, 'YData', [ewp2(2), ewp4(2)]);
            set(eharm52, 'ZData', [ewp2(3), ewp4(3)]);
            set(ehmap5, 'XData', emap(1, :));
            set(ehmap5, 'YData', emap(2, :));
            set(ehmap5, 'ZData', emap(3, :));
            set(ehwindow5, 'XData', ewindow(1, :));
            set(ehwindow5, 'YData', ewindow(2, :));
            set(ehwindow5, 'ZData', ewindow(3, :));
        end


        hold on;

        grid on;


        twp1 = true_s(1:3, 6) + tpoint1;
        twp2 = true_s(1:3, 6) + tpoint2;
        twp3 = true_s(1:3, 6) + tpoint3;
        twp4 = true_s(1:3, 6) + tpoint4;
        tprop1 = tproppts + twp1 * ones(1, nprop);
        tprop2 = tproppts + twp2 * ones(1, nprop);
        tprop3 = tproppts + twp3 * ones(1, nprop);
        tprop4 = tproppts + twp4 * ones(1, nprop);
        tfov0 = true_s(1:3, 6);
        tfov1 = tR * [ff; ff * tan(ifov*pi/180/2); ff * tan(ifov*pi/180/2)] + true_s(1:3, 6);
        tfov2 = tR * [ff; ff * tan(ifov*pi/180/2); -ff * tan(ifov*pi/180/2)] + true_s(1:3, 6);
        tfov3 = tR * [ff; -ff * tan(ifov*pi/180/2); -ff * tan(ifov*pi/180/2)] + true_s(1:3, 6);
        tfov4 = tR * [ff; -ff * tan(ifov*pi/180/2); ff * tan(ifov*pi/180/2)] + true_s(1:3, 6);
        eR = QuatToRot(s_des(7:10, 6))';
        epoint1 = eR * [ll; 0; 0];
        epoint2 = eR * [0; ll; 0];
        epoint3 = eR * [-ll; 0; 0];
        epoint4 = eR * [0; -ll; 0];
        eproppts = rr * eR * [cos(propangs); sin(propangs); zeros(1, nprop)];


        ewp1 = s_des(1:3, 6) + epoint1;
        ewp2 = s_des(1:3, 6) + epoint2;
        ewp3 = s_des(1:3, 6) + epoint3;
        ewp4 = s_des(1:3, 6) + epoint4;

        eprop1 = eproppts + ewp1 * ones(1, nprop);
        eprop2 = eproppts + ewp2 * ones(1, nprop);
        eprop3 = eproppts + ewp3 * ones(1, nprop);
        eprop4 = eproppts + ewp4 * ones(1, nprop);
        emap = [0; 0; 0];
        ewindow = [0; 0; 0];

        if ~vis_init
            thtraj6 = plot3(true_s(1, 6), true_s(2, 6), true_s(3, 6), 'b-', 'LineWidth', 0.5);
            tharm1 = line([twp1(1), twp3(1)], [twp1(2), twp3(2)], [twp1(3), twp3(3)], 'Color', 'b');
            tharm2 = line([twp2(1), twp4(1)], [twp2(2), twp4(2)], [twp2(3), twp4(3)], 'Color', 'b');
            thprop1 = plot3(tprop1(1, :), tprop1(2, :), tprop1(3, :), 'r-');
            thprop2 = plot3(tprop2(1, :), tprop2(2, :), tprop2(3, :), 'b-');
            thprop3 = plot3(tprop3(1, :), tprop3(2, :), tprop3(3, :), 'b-');
            thprop4 = plot3(tprop4(1, :), tprop4(2, :), tprop4(3, :), 'b-');
            thfov1 = line([tfov0(1), tfov1(1), tfov2(1)], [tfov0(2), tfov1(2), tfov2(2)], [tfov0(3), tfov1(3), tfov2(3)], 'Color', 'k');
            thfov2 = line([tfov0(1), tfov2(1), tfov3(1)], [tfov0(2), tfov2(2), tfov3(2)], [tfov0(3), tfov2(3), tfov3(3)], 'Color', 'k');
            thfov3 = line([tfov0(1), tfov3(1), tfov4(1)], [tfov0(2), tfov3(2), tfov4(2)], [tfov0(3), tfov3(3), tfov4(3)], 'Color', 'k');
            thfov4 = line([tfov0(1), tfov4(1), tfov1(1)], [tfov0(2), tfov4(2), tfov1(2)], [tfov0(3), tfov4(3), tfov1(3)], 'Color', 'k');

            ehtraj6 = plot3(s_des(1, 6), s_des(2, 6), s_des(3, 6), 'g-', 'LineWidth', 0.5);

            eharm1 = line([ewp1(1), ewp3(1)], [ewp1(2), ewp3(2)], [ewp1(3), ewp3(3)], 'Color', 'g');
            eharm2 = line([ewp2(1), ewp4(1)], [ewp2(2), ewp4(2)], [ewp2(3), ewp4(3)], 'Color', 'g');
            ehprop1 = plot3(eprop1(1, :), eprop1(2, :), eprop1(3, :), 'm-');
            ehprop2 = plot3(eprop2(1, :), eprop2(2, :), eprop2(3, :), 'g-');
            ehprop3 = plot3(eprop3(1, :), eprop3(2, :), eprop3(3, :), 'g-');
            ehprop4 = plot3(eprop4(1, :), eprop4(2, :), eprop4(3, :), 'g-');
            ehmap = plot3(emap(1, :), emap(2, :), emap(3, :), 'ko', 'MarkerSize', 10, 'MarkerFaceColor', 'k');
            ehwindow = plot3(ewindow(1, :), ewindow(2, :), ewindow(3, :), 'ro', 'MarkerSize', 5, 'MarkerFaceColor', 'r');
        else
            set(thtraj6, 'XData', [get(thtraj6, 'XData'), true_s(1, 6)]);
            set(thtraj6, 'YData', [get(thtraj6, 'YData'), true_s(2, 6)]);
            set(thtraj6, 'ZData', [get(thtraj6, 'ZData'), true_s(3, 6)]);
            set(thprop1, 'XData', tprop1(1, :));
            set(thprop1, 'YData', tprop1(2, :));
            set(thprop1, 'ZData', tprop1(3, :));
            set(thprop2, 'XData', tprop2(1, :));
            set(thprop2, 'YData', tprop2(2, :));
            set(thprop2, 'ZData', tprop2(3, :));
            set(thprop3, 'XData', tprop3(1, :));
            set(thprop3, 'YData', tprop3(2, :));
            set(thprop3, 'ZData', tprop3(3, :));
            set(thprop4, 'XData', tprop4(1, :));
            set(thprop4, 'YData', tprop4(2, :));
            set(thprop4, 'ZData', tprop4(3, :));
            set(tharm1, 'XData', [twp1(1), twp3(1)]);
            set(tharm1, 'YData', [twp1(2), twp3(2)]);
            set(tharm1, 'ZData', [twp1(3), twp3(3)]);
            set(tharm2, 'XData', [twp2(1), twp4(1)]);
            set(tharm2, 'YData', [twp2(2), twp4(2)]);
            set(tharm2, 'ZData', [twp2(3), twp4(3)]);
            set(thfov1, 'XData', [tfov0(1), tfov1(1), tfov2(1)]);
            set(thfov1, 'YData', [tfov0(2), tfov1(2), tfov2(2)]);
            set(thfov1, 'ZData', [tfov0(3), tfov1(3), tfov2(3)]);
            set(thfov2, 'XData', [tfov0(1), tfov2(1), tfov3(1)]);
            set(thfov2, 'YData', [tfov0(2), tfov2(2), tfov3(2)]);
            set(thfov2, 'ZData', [tfov0(3), tfov2(3), tfov3(3)]);
            set(thfov3, 'XData', [tfov0(1), tfov3(1), tfov4(1)]);
            set(thfov3, 'YData', [tfov0(2), tfov3(2), tfov4(2)]);
            set(thfov3, 'ZData', [tfov0(3), tfov3(3), tfov4(3)]);
            set(thfov4, 'XData', [tfov0(1), tfov4(1), tfov1(1)]);
            set(thfov4, 'YData', [tfov0(2), tfov4(2), tfov1(2)]);
            set(thfov4, 'ZData', [tfov0(3), tfov4(3), tfov1(3)]);
            set(ehtraj6, 'XData', [get(ehtraj6, 'XData'), s_des(1, 6)]);
            set(ehtraj6, 'YData', [get(ehtraj6, 'YData'), s_des(2, 6)]);
            set(ehtraj6, 'ZData', [get(ehtraj6, 'ZData'), s_des(3, 6)]);
            set(ehprop1, 'XData', eprop1(1, :));
            set(ehprop1, 'YData', eprop1(2, :));
            set(ehprop1, 'ZData', eprop1(3, :));
            set(ehprop2, 'XData', eprop2(1, :));
            set(ehprop2, 'YData', eprop2(2, :));
            set(ehprop2, 'ZData', eprop2(3, :));
            set(ehprop3, 'XData', eprop3(1, :));
            set(ehprop3, 'YData', eprop3(2, :));
            set(ehprop3, 'ZData', eprop3(3, :));
            set(ehprop4, 'XData', eprop4(1, :));
            set(ehprop4, 'YData', eprop4(2, :));
            set(ehprop4, 'ZData', eprop4(3, :));
            set(eharm1, 'XData', [ewp1(1), ewp3(1)]);
            set(eharm1, 'YData', [ewp1(2), ewp3(2)]);
            set(eharm1, 'ZData', [ewp1(3), ewp3(3)]);
            set(eharm2, 'XData', [ewp2(1), ewp4(1)]);
            set(eharm2, 'YData', [ewp2(2), ewp4(2)]);
            set(eharm2, 'ZData', [ewp2(3), ewp4(3)]);
            set(ehmap, 'XData', emap(1, :));
            set(ehmap, 'YData', emap(2, :));
            set(ehmap, 'ZData', emap(3, :));
            set(ehwindow, 'XData', ewindow(1, :));
            set(ehwindow, 'YData', ewindow(2, :));
            set(ehwindow, 'ZData', ewindow(3, :));
        end
%         CurrFrame = getframe(gcf);   % 获取像素，否则无法显示动画
%         im = frame2im(CurrFrame);  
%         [A,map] = rgb2ind(im,256);  % 将RGB图像转换为索引图像
% 	    if i == 1
% 		    imwrite(A,map,'test.gif','gif','LoopCount',Inf,'DelayTime',0.01);  % DelayTime表示写入的时间间隔
% 	    else
% 		    imwrite(A,map,'test.gif','gif','WriteMode','append','DelayTime',0.01);
%         end
        hold off
        if flag ~= 1
            %% Plot roll oriengation
            subplot(h2);
            true_ypr = R_to_ypr(quaternion_to_R(true_s(7:10, 1))') * 180 / pi;
            if ~vis_init
                hold on;
                throll = plot(time, true_ypr(3), 'r-', 'LineWidth', 1);
                hold off;
                xlabel('Time (s)');
                ylabel('roll1 degree');
                axis([0, time_tol, -45, 45]);
            else
                hold on;
                set(throll, 'XData', [get(throll, 'XData'), time]);
                set(throll, 'YData', [get(throll, 'YData'), true_ypr(3)]);
                hold off;
            end
    
            subplot(h10);
            true_ypr2 = R_to_ypr(quaternion_to_R(true_s(7:10, 2))') * 180 / pi;
            if ~vis_init
                hold on;
                throll2 = plot(time, true_ypr2(3), 'r-', 'LineWidth', 1);
                hold off;
                xlabel('Time (s)');
                ylabel('roll2 degree');
                axis([0, time_tol, -45, 45]);
            else
                hold on;
                set(throll2, 'XData', [get(throll2, 'XData'), time]);
                set(throll2, 'YData', [get(throll2, 'YData'), true_ypr(3)]);
                hold off;
            end
    
            subplot(h18);
            true_ypr3 = R_to_ypr(quaternion_to_R(true_s(7:10, 3))') * 180 / pi;
            if ~vis_init
                hold on;
                throll3 = plot(time, true_ypr3(3), 'r-', 'LineWidth', 1);
                hold off;
                xlabel('Time (s)');
                ylabel('roll3 degree');
                axis([0, time_tol, -45, 45]);
            else
                hold on;
                set(throll3, 'XData', [get(throll3, 'XData'), time]);
                set(throll3, 'YData', [get(throll3, 'YData'), true_ypr(3)]);
                hold off;
            end
    
    
            subplot(h26);
            true_ypr4 = R_to_ypr(quaternion_to_R(true_s(7:10, 4))') * 180 / pi;
            if ~vis_init
                hold on;
                throll4 = plot(time, true_ypr4(3), 'r-', 'LineWidth', 1);
                hold off;
                xlabel('Time (s)');
                ylabel('roll4 degree');
                axis([0, time_tol, -45, 45]);
            else
                hold on;
                set(throll4, 'XData', [get(throll4, 'XData'), time]);
                set(throll4, 'YData', [get(throll4, 'YData'), true_ypr(3)]);
                hold off;
            end
    
            subplot(h34);
            true_ypr5 = R_to_ypr(quaternion_to_R(true_s(7:10, 5))') * 180 / pi;
            if ~vis_init
                hold on;
                throll5 = plot(time, true_ypr5(3), 'r-', 'LineWidth', 1);
                hold off;
                xlabel('Time (s)');
                ylabel('roll5 degree');
                axis([0, time_tol, -45, 45]);
            else
                hold on;
                set(throll5, 'XData', [get(throll5, 'XData'), time]);
                set(throll5, 'YData', [get(throll5, 'YData'), true_ypr(3)]);
                hold off;
            end
    
            subplot(h42);
            true_ypr6 = R_to_ypr(quaternion_to_R(true_s(7:10, 6))') * 180 / pi;
            if ~vis_init
                hold on;
                throll6 = plot(time, true_ypr6(3), 'r-', 'LineWidth', 1);
                hold off;
                xlabel('Time (s)');
                ylabel('roll6 degree');
                axis([0, time_tol, -45, 45]);
            else
                hold on;
                set(throll6, 'XData', [get(throll6, 'XData'), time]);
                set(throll6, 'YData', [get(throll6, 'YData'), true_ypr(3)]);
                hold off;
            end
    
            %% Plot pitch orientation
            % quadrotor 1
            subplot(h3);
            if ~vis_init
                hold on;
                thpitch = plot(time, true_ypr(2), 'r-', 'LineWidth', 1);
                hold off;
                xlabel('Time (s)');
                ylabel('pitch1 degree');
                axis([0, time_tol, -45, 45]);
            else
                hold on;
                set(thpitch, 'XData', [get(thpitch, 'XData'), time]);
                set(thpitch, 'YData', [get(thpitch, 'YData'), true_ypr(2)]);
                hold off;
            end
            % quadrotor 2
            subplot(h11);
            if ~vis_init
                hold on;
                thpitch2 = plot(time, true_ypr2(2), 'r-', 'LineWidth', 1);
                hold off;
                xlabel('Time (s)');
                ylabel('pitch2 degree');
                axis([0, time_tol, -45, 45]);
            else
                hold on;
                set(thpitch2, 'XData', [get(thpitch2, 'XData'), time]);
                set(thpitch2, 'YData', [get(thpitch2, 'YData'), true_ypr(2)]);
                hold off;
            end
    
            % quadrotor 3
            subplot(h19);
            if ~vis_init
                hold on;
                thpitch3 = plot(time, true_ypr3(2), 'r-', 'LineWidth', 1);
                hold off;
                xlabel('Time (s)');
                ylabel('pitch3 degree');
                axis([0, time_tol, -45, 45]);
            else
                hold on;
                set(thpitch3, 'XData', [get(thpitch3, 'XData'), time]);
                set(thpitch3, 'YData', [get(thpitch3, 'YData'), true_ypr(2)]);
                hold off;
            end
            % quadrotor 4
            subplot(h27);
            if ~vis_init
                hold on;
                thpitch4 = plot(time, true_ypr4(2), 'r-', 'LineWidth', 1);
                hold off;
                xlabel('Time (s)');
                ylabel('pitch4 degree');
                axis([0, time_tol, -45, 45]);
            else
                hold on;
                set(thpitch4, 'XData', [get(thpitch4, 'XData'), time]);
                set(thpitch4, 'YData', [get(thpitch4, 'YData'), true_ypr(2)]);
                hold off;
            end
    
            % quadrotor 5
            subplot(h35);
            if ~vis_init
                hold on;
                thpitch5 = plot(time, true_ypr5(2), 'r-', 'LineWidth', 1);
                hold off;
                xlabel('Time (s)');
                ylabel('pitch5 degree');
                axis([0, time_tol, -45, 45]);
            else
                hold on;
                set(thpitch5, 'XData', [get(thpitch5, 'XData'), time]);
                set(thpitch5, 'YData', [get(thpitch5, 'YData'), true_ypr(2)]);
                hold off;
            end
    
            % quadrotor 6
            subplot(h43);
            if ~vis_init
                hold on;
                thpitch6 = plot(time, true_ypr6(2), 'r-', 'LineWidth', 1);
                hold off;
                xlabel('Time (s)');
                ylabel('pitch6 degree');
                axis([0, time_tol, -45, 45]);
            else
                hold on;
                set(thpitch6, 'XData', [get(thpitch6, 'XData'), time]);
                set(thpitch6, 'YData', [get(thpitch6, 'YData'), true_ypr(2)]);
                hold off;
            end
    
            %% Plot body frame velocity
            % quadrotor 1
            subplot(h4);
            true_v1 = true_s(4:6, 1);
            des_v1 = s_des(4:6, 1);
            if ~vis_init
                hold on;
                thvx1 = plot(time, true_v1(1), 'r-', 'LineWidth', 1);
                ehvx1 = plot(time, des_v1(1), 'b-', 'LineWidth', 1);
                hold off;
                xlabel('Time (s)');
                ylabel('X1 World Velocity (m/s)');
                axis([0, time_tol, -3, 3]);
            else
                hold on;
                set(thvx1, 'XData', [get(thvx1, 'XData'), time]);
                set(thvx1, 'YData', [get(thvx1, 'YData'), true_v1(1)]);
                set(ehvx1, 'XData', [get(ehvx1, 'XData'), time]);
                set(ehvx1, 'YData', [get(ehvx1, 'YData'), des_v1(1)]);
                hold off;
            end
    
            % quadrotor 2
            subplot(h12);
            true_v2 = true_s(4:6, 2);
            des_v2 = s_des(4:6, 2);
            if ~vis_init
                hold on;
                thvx2 = plot(time, true_v2(1), 'r-', 'LineWidth', 1);
                ehvx2 = plot(time, des_v2(1), 'b-', 'LineWidth', 1);
                hold off;
                xlabel('Time (s)');
                ylabel('X2 World Velocity (m/s)');
                axis([0, time_tol, -3, 3]);
            else
                hold on;
                set(thvx2, 'XData', [get(thvx2, 'XData'), time]);
                set(thvx2, 'YData', [get(thvx2, 'YData'), true_v2(1)]);
                set(ehvx2, 'XData', [get(ehvx2, 'XData'), time]);
                set(ehvx2, 'YData', [get(ehvx2, 'YData'), des_v2(1)]);
                hold off;
            end
    
            % quadrotor 3
            subplot(h20);
            true_v3 = true_s(4:6, 3);
            des_v3 = s_des(4:6, 3);
            if ~vis_init
                hold on;
                thvx3 = plot(time, true_v3(1), 'r-', 'LineWidth', 1);
                ehvx3 = plot(time, des_v3(1), 'b-', 'LineWidth', 1);
                hold off;
                xlabel('Time (s)');
                ylabel('X3 World Velocity (m/s)');
                axis([0, time_tol, -3, 3]);
            else
                hold on;
                set(thvx3, 'XData', [get(thvx3, 'XData'), time]);
                set(thvx3, 'YData', [get(thvx3, 'YData'), true_v3(1)]);
                set(ehvx3, 'XData', [get(ehvx3, 'XData'), time]);
                set(ehvx3, 'YData', [get(ehvx3, 'YData'), des_v3(1)]);
                hold off;
            end
    
            % quadrotor 4
            subplot(h28);
            true_v4 = true_s(4:6, 4);
            des_v4 = s_des(4:6, 4);
            if ~vis_init
                hold on;
                thvx4 = plot(time, true_v4(1), 'r-', 'LineWidth', 1);
                ehvx4 = plot(time, des_v4(1), 'b-', 'LineWidth', 1);
                hold off;
                xlabel('Time (s)');
                ylabel('X4 World Velocity (m/s)');
                axis([0, time_tol, -3, 3]);
            else
                hold on;
                set(thvx4, 'XData', [get(thvx4, 'XData'), time]);
                set(thvx4, 'YData', [get(thvx4, 'YData'), true_v4(1)]);
                set(ehvx4, 'XData', [get(ehvx4, 'XData'), time]);
                set(ehvx4, 'YData', [get(ehvx4, 'YData'), des_v4(1)]);
                hold off;
            end
            % quadrotor 5
            subplot(h36);
            true_v5 = true_s(4:6, 5);
            des_v5 = s_des(4:6, 5);
            if ~vis_init
                hold on;
                thvx5 = plot(time, true_v5(1), 'r-', 'LineWidth', 1);
                ehvx5 = plot(time, des_v5(1), 'b-', 'LineWidth', 1);
                hold off;
                xlabel('Time (s)');
                ylabel('X5 World Velocity (m/s)');
                axis([0, time_tol, -3, 3]);
            else
                hold on;
                set(thvx5, 'XData', [get(thvx5, 'XData'), time]);
                set(thvx5, 'YData', [get(thvx5, 'YData'), true_v4(1)]);
                set(ehvx5, 'XData', [get(ehvx5, 'XData'), time]);
                set(ehvx5, 'YData', [get(ehvx5, 'YData'), des_v4(1)]);
                hold off;
            end
            % quadrotor 6
            subplot(h44);
            true_v6 = true_s(4:6, 6);
            des_v6 = s_des(4:6, 6);
            if ~vis_init
                hold on;
                thvx6 = plot(time, true_v6(1), 'r-', 'LineWidth', 1);
                ehvx6 = plot(time, des_v6(1), 'b-', 'LineWidth', 1);
                hold off;
                xlabel('Time (s)');
                ylabel('X6 World Velocity (m/s)');
                axis([0, time_tol, -3, 3]);
            else
                hold on;
                set(thvx6, 'XData', [get(thvx6, 'XData'), time]);
                set(thvx6, 'YData', [get(thvx6, 'YData'), true_v4(1)]);
                set(ehvx6, 'XData', [get(ehvx6, 'XData'), time]);
                set(ehvx6, 'YData', [get(ehvx6, 'YData'), des_v4(1)]);
                hold off;
            end
    
            %y轴速度
            %quadrotor 1
            subplot(h5);
            if ~vis_init
                hold on;
                thvy1 = plot(time, true_v1(2), 'r-', 'LineWidth', 1);
                ehvy1 = plot(time, des_v1(2), 'b-', 'LineWidth', 1);
                hold off;
                xlabel('Time (s)');
                ylabel('Y1 World Velocity (m/s)');
                axis([0, time_tol, -3, 3]);
            else
                hold on;
                set(thvy1, 'XData', [get(thvy1, 'XData'), time]);
                set(thvy1, 'YData', [get(thvy1, 'YData'), true_v1(2)]);
                set(ehvy1, 'XData', [get(ehvy1, 'XData'), time]);
                set(ehvy1, 'YData', [get(ehvy1, 'YData'), des_v1(2)]);
                hold off;
            end
    
            %quadrotor 2
            subplot(h13);
            if ~vis_init
                hold on;
                thvy2 = plot(time, true_v2(2), 'r-', 'LineWidth', 1);
                ehvy2 = plot(time, des_v2(2), 'b-', 'LineWidth', 1);
                hold off;
                xlabel('Time (s)');
                ylabel('Y2 World Velocity (m/s)');
                axis([0, time_tol, -3, 3]);
            else
                hold on;
                set(thvy2, 'XData', [get(thvy2, 'XData'), time]);
                set(thvy2, 'YData', [get(thvy2, 'YData'), true_v2(2)]);
                set(ehvy2, 'XData', [get(ehvy2, 'XData'), time]);
                set(ehvy2, 'YData', [get(ehvy2, 'YData'), des_v2(2)]);
                hold off;
            end
    
    
            %quadrotor 3
            subplot(h21);
            if ~vis_init
                hold on;
                thvy3 = plot(time, true_v3(2), 'r-', 'LineWidth', 1);
                ehvy3 = plot(time, des_v3(2), 'b-', 'LineWidth', 1);
                hold off;
                xlabel('Time (s)');
                ylabel('Y3 World Velocity (m/s)');
                axis([0, time_tol, -3, 3]);
            else
                hold on;
                set(thvy3, 'XData', [get(thvy3, 'XData'), time]);
                set(thvy3, 'YData', [get(thvy3, 'YData'), true_v3(2)]);
                set(ehvy3, 'XData', [get(ehvy3, 'XData'), time]);
                set(ehvy3, 'YData', [get(ehvy3, 'YData'), des_v3(2)]);
                hold off;
            end
    
    
            %quadrotor 4
            subplot(h29);
            if ~vis_init
                hold on;
                thvy4 = plot(time, true_v1(2), 'r-', 'LineWidth', 1);
                ehvy4 = plot(time, des_v1(2), 'b-', 'LineWidth', 1);
                hold off;
                xlabel('Time (s)');
                ylabel('Y4 World Velocity (m/s)');
                axis([0, time_tol, -3, 3]);
            else
                hold on;
                set(thvy4, 'XData', [get(thvy4, 'XData'), time]);
                set(thvy4, 'YData', [get(thvy4, 'YData'), true_v4(2)]);
                set(ehvy4, 'XData', [get(ehvy4, 'XData'), time]);
                set(ehvy4, 'YData', [get(ehvy4, 'YData'), des_v4(2)]);
                hold off;
            end
    
            %quadrotor 5
            subplot(h37);
            if ~vis_init
                hold on;
                thvy5 = plot(time, true_v5(2), 'r-', 'LineWidth', 1);
                ehvy5 = plot(time, des_v5(2), 'b-', 'LineWidth', 1);
                hold off;
                xlabel('Time (s)');
                ylabel('Y5 World Velocity (m/s)');
                axis([0, time_tol, -3, 3]);
            else
                hold on;
                set(thvy5, 'XData', [get(thvy5, 'XData'), time]);
                set(thvy5, 'YData', [get(thvy5, 'YData'), true_v5(2)]);
                set(ehvy5, 'XData', [get(ehvy5, 'XData'), time]);
                set(ehvy5, 'YData', [get(ehvy5, 'YData'), des_v5(2)]);
                hold off;
            end
    
            %quadrotor 6
            subplot(h45);
            if ~vis_init
                hold on;
                thvy6 = plot(time, true_v6(2), 'r-', 'LineWidth', 1);
                ehvy6 = plot(time, des_v6(2), 'b-', 'LineWidth', 1);
                hold off;
                xlabel('Time (s)');
                ylabel('Y6 World Velocity (m/s)');
                axis([0, time_tol, -3, 3]);
            else
                hold on;
                set(thvy6, 'XData', [get(thvy6, 'XData'), time]);
                set(thvy6, 'YData', [get(thvy6, 'YData'), true_v6(2)]);
                set(ehvy6, 'XData', [get(ehvy6, 'XData'), time]);
                set(ehvy6, 'YData', [get(ehvy6, 'YData'), des_v6(2)]);
                hold off;
            end
    
            %quadrotor 1
            subplot(h6);
            if ~vis_init
                hold on;
                thvz1 = plot(time, true_v1(3), 'r-', 'LineWidth', 1);
                ehvz1 = plot(time, des_v1(3), 'b-', 'LineWidth', 1);
                hold off;
                xlabel('Time (s)');
                ylabel('Z1 World Velocity (m/s)');
                axis([0, time_tol, -1, 1]);
            else
                hold on;
                set(thvz1, 'XData', [get(thvz1, 'XData'), time]);
                set(thvz1, 'YData', [get(thvz1, 'YData'), true_v1(3)]);
                set(ehvz1, 'XData', [get(ehvz1, 'XData'), time]);
                set(ehvz1, 'YData', [get(ehvz1, 'YData'), des_v1(3)]);
                hold off;
            end
    
            %quadrotor 2
            subplot(h14);
            if ~vis_init
                hold on;
                thvz2 = plot(time, true_v2(3), 'r-', 'LineWidth', 1);
                ehvz2 = plot(time, des_v2(3), 'b-', 'LineWidth', 1);
                hold off;
                xlabel('Time (s)');
                ylabel('Z2 World Velocity (m/s)');
                axis([0, time_tol, -1, 1]);
            else
                hold on;
                set(thvz2, 'XData', [get(thvz2, 'XData'), time]);
                set(thvz2, 'YData', [get(thvz2, 'YData'), true_v2(3)]);
                set(ehvz2, 'XData', [get(ehvz2, 'XData'), time]);
                set(ehvz2, 'YData', [get(ehvz2, 'YData'), des_v2(3)]);
                hold off;
            end
    
            %quadrotor 3
            subplot(h22);
            if ~vis_init
                hold on;
                thvz3 = plot(time, true_v3(3), 'r-', 'LineWidth', 1);
                ehvz3 = plot(time, des_v3(3), 'b-', 'LineWidth', 1);
                hold off;
                xlabel('Time (s)');
                ylabel('Z3 World Velocity (m/s)');
                axis([0, time_tol, -1, 1]);
            else
                hold on;
                set(thvz3, 'XData', [get(thvz3, 'XData'), time]);
                set(thvz3, 'YData', [get(thvz3, 'YData'), true_v3(3)]);
                set(ehvz3, 'XData', [get(ehvz3, 'XData'), time]);
                set(ehvz3, 'YData', [get(ehvz3, 'YData'), des_v3(3)]);
                hold off;
            end
    
            %quadrotor 4
            subplot(h30);
            if ~vis_init
                hold on;
                thvz4 = plot(time, true_v4(3), 'r-', 'LineWidth', 1);
                ehvz4 = plot(time, des_v4(3), 'b-', 'LineWidth', 1);
                hold off;
                xlabel('Time (s)');
                ylabel('Z4 World Velocity (m/s)');
                axis([0, time_tol, -1, 1]);
            else
                hold on;
                set(thvz4, 'XData', [get(thvz4, 'XData'), time]);
                set(thvz4, 'YData', [get(thvz4, 'YData'), true_v4(3)]);
                set(ehvz4, 'XData', [get(ehvz4, 'XData'), time]);
                set(ehvz4, 'YData', [get(ehvz4, 'YData'), des_v4(3)]);
                hold off;
            end
    
            %quadrotor 5
            subplot(h38);
            if ~vis_init
                hold on;
                thvz5 = plot(time, true_v5(3), 'r-', 'LineWidth', 1);
                ehvz5 = plot(time, des_v5(3), 'b-', 'LineWidth', 1);
                hold off;
                xlabel('Time (s)');
                ylabel('Z5 World Velocity (m/s)');
                axis([0, time_tol, -1, 1]);
            else
                hold on;
                set(thvz5, 'XData', [get(thvz5, 'XData'), time]);
                set(thvz5, 'YData', [get(thvz5, 'YData'), true_v5(3)]);
                set(ehvz5, 'XData', [get(ehvz5, 'XData'), time]);
                set(ehvz5, 'YData', [get(ehvz5, 'YData'), des_v5(3)]);
                hold off;
            end
    
            %quadrotor 6
            subplot(h46);
            if ~vis_init
                hold on;
                thvz6 = plot(time, true_v6(3), 'r-', 'LineWidth', 1);
                ehvz6 = plot(time, des_v6(3), 'b-', 'LineWidth', 1);
                hold off;
                xlabel('Time (s)');
                ylabel('Z6 World Velocity (m/s)');
                axis([0, time_tol, -1, 1]);
            else
                hold on;
                set(thvz6, 'XData', [get(thvz6, 'XData'), time]);
                set(thvz6, 'YData', [get(thvz6, 'YData'), true_v6(3)]);
                set(ehvz6, 'XData', [get(ehvz6, 'XData'), time]);
                set(ehvz6, 'YData', [get(ehvz6, 'YData'), des_v6(3)]);
                hold off;
            end
    
            %% Plot world frame position
    
            %% quadrotor 1
            subplot(h7);
            true_p1 = true_s(1:3, 1);
            des_p1 = s_des(1:3, 1);
            if ~vis_init
                hold on;
                thpx1 = plot(time, true_p1(1), 'r-', 'LineWidth', 1);
                ehpx1 = plot(time, des_p1(1), 'b-', 'LineWidth', 1);
                hold off;
                xlabel('Time (s)');
                ylabel('X1 World Position (m)');
                axis([0, time_tol, -3, 20]);
            else
                hold on;
                set(thpx1, 'XData', [get(thpx1, 'XData'), time]);
                set(thpx1, 'YData', [get(thpx1, 'YData'), true_p1(1)]);
                set(ehpx1, 'XData', [get(ehpx1, 'XData'), time]);
                set(ehpx1, 'YData', [get(ehpx1, 'YData'), des_p1(1)]);
                hold off;
            end
    
            subplot(h8);
            axis([0, 20, -3, 10]);
            if ~vis_init
                hold on;
                thpy1 = plot(time, true_p1(2), 'r-', 'LineWidth', 1);
                ehpy1 = plot(time, des_p1(2), 'b-', 'LineWidth', 1);
                hold off;
                xlabel('Time (s) ');
                ylabel('Y1 World Position (m)');
                axis([0, time_tol, -3, 3]);
            else
                hold on;
                set(thpy1, 'XData', [get(thpy1, 'XData'), time]);
                set(thpy1, 'YData', [get(thpy1, 'YData'), true_p1(2)]);
                set(ehpy1, 'XData', [get(ehpy1, 'XData'), time]);
                set(ehpy1, 'YData', [get(ehpy1, 'YData'), des_p1(2)]);
                hold off;
            end
            subplot(h9);
            if ~vis_init
                hold on;
                thpz1 = plot(time, true_p1(3), 'r-', 'LineWidth', 1);
                ehpz1 = plot(time, des_p1(3), 'b-', 'LineWidth', 1);
                hold off;
                xlabel('Time (s)');
                ylabel('Z1 World Position (m)');
                axis([0, time_tol, -3, 3]);
            else
                hold on;
                set(thpz1, 'XData', [get(thpz1, 'XData'), time]);
                set(thpz1, 'YData', [get(thpz1, 'YData'), true_p1(3)])
                set(ehpz1, 'XData', [get(ehpz1, 'XData'), time]);
                set(ehpz1, 'YData', [get(ehpz1, 'YData'), des_p1(3)]);
                hold off;
            end
    
            %% quadrotor 2
            subplot(h15);
            true_p2 = true_s(1:3, 2);
            des_p2 = s_des(1:3, 2);
            if ~vis_init
                hold on;
                thpx2 = plot(time, true_p2(1), 'r-', 'LineWidth', 1);
                ehpx2 = plot(time, des_p2(1), 'b-', 'LineWidth', 1);
                hold off;
                xlabel('Time (s)');
                ylabel('X2 World Position (m)');
                axis([0, time_tol, -3, 20]);
            else
                hold on;
                set(thpx2, 'XData', [get(thpx2, 'XData'), time]);
                set(thpx2, 'YData', [get(thpx2, 'YData'), true_p2(1)]);
                set(ehpx2, 'XData', [get(ehpx2, 'XData'), time]);
                set(ehpx2, 'YData', [get(ehpx2, 'YData'), des_p2(1)]);
                hold off;
            end
    
            subplot(h16);
            axis([0, 20, -3, 10]);
            if ~vis_init
                hold on;
                thpy2 = plot(time, true_p2(2), 'r-', 'LineWidth', 1);
                ehpy2 = plot(time, des_p2(2), 'b-', 'LineWidth', 1);
                hold off;
                xlabel('Time (s) ');
                ylabel('Y2 World Position (m)');
                axis([0, time_tol, -3, 3]);
            else
                hold on;
                set(thpy2, 'XData', [get(thpy2, 'XData'), time]);
                set(thpy2, 'YData', [get(thpy2, 'YData'), true_p2(2)]);
                set(ehpy2, 'XData', [get(ehpy2, 'XData'), time]);
                set(ehpy2, 'YData', [get(ehpy2, 'YData'), des_p2(2)]);
                hold off;
            end
            subplot(h17);
            if ~vis_init
                hold on;
                thpz2 = plot(time, true_p2(3), 'r-', 'LineWidth', 1);
                ehpz2 = plot(time, des_p2(3), 'b-', 'LineWidth', 1);
                hold off;
                xlabel('Time (s)');
                ylabel('Z2 World Position (m)');
                axis([0, time_tol, -3, 3]);
            else
                hold on;
                set(thpz2, 'XData', [get(thpz2, 'XData'), time]);
                set(thpz2, 'YData', [get(thpz2, 'YData'), true_p2(3)])
                set(ehpz2, 'XData', [get(ehpz2, 'XData'), time]);
                set(ehpz2, 'YData', [get(ehpz2, 'YData'), des_p2(3)]);
                hold off;
            end
    
            %% quadrotor 3
            subplot(h23);
            true_p3 = true_s(1:3, 3);
            des_p3 = s_des(1:3, 3);
            if ~vis_init
                hold on;
                thpx3 = plot(time, true_p3(1), 'r-', 'LineWidth', 1);
                ehpx3 = plot(time, des_p3(1), 'b-', 'LineWidth', 1);
                hold off;
                xlabel('Time (s)');
                ylabel('X3 World Position (m)');
                axis([0, time_tol, -3, 20]);
            else
                hold on;
                set(thpx3, 'XData', [get(thpx3, 'XData'), time]);
                set(thpx3, 'YData', [get(thpx3, 'YData'), true_p3(1)]);
                set(ehpx3, 'XData', [get(ehpx3, 'XData'), time]);
                set(ehpx3, 'YData', [get(ehpx3, 'YData'), des_p3(1)]);
                hold off;
            end
    
            subplot(h24);
            axis([0, 20, -3, 10]);
            if ~vis_init
                hold on;
                thpy3 = plot(time, true_p3(2), 'r-', 'LineWidth', 1);
                ehpy3 = plot(time, des_p3(2), 'b-', 'LineWidth', 1);
                hold off;
                xlabel('Time (s) ');
                ylabel('Y3 World Position (m)');
                axis([0, time_tol, -3, 3]);
            else
                hold on;
                set(thpy3, 'XData', [get(thpy3, 'XData'), time]);
                set(thpy3, 'YData', [get(thpy3, 'YData'), true_p3(2)]);
                set(ehpy3, 'XData', [get(ehpy3, 'XData'), time]);
                set(ehpy3, 'YData', [get(ehpy3, 'YData'), des_p3(2)]);
                hold off;
            end
            subplot(h25);
            if ~vis_init
                hold on;
                thpz3 = plot(time, true_p3(3), 'r-', 'LineWidth', 1);
                ehpz3 = plot(time, des_p3(3), 'b-', 'LineWidth', 1);
                hold off;
                xlabel('Time (s)');
                ylabel('Z3 World Position (m)');
                axis([0, time_tol, -3, 3]);
            else
                hold on;
                set(thpz3, 'XData', [get(thpz3, 'XData'), time]);
                set(thpz3, 'YData', [get(thpz3, 'YData'), true_p3(3)])
                set(ehpz3, 'XData', [get(ehpz3, 'XData'), time]);
                set(ehpz3, 'YData', [get(ehpz3, 'YData'), des_p3(3)]);
                hold off;
            end
    
            %% quadrotor 4
            subplot(h31);
            true_p4 = true_s(1:3, 4);
            des_p4 = s_des(1:3, 4);
            if ~vis_init
                hold on;
                thpx4 = plot(time, true_p4(1), 'r-', 'LineWidth', 1);
                ehpx4 = plot(time, des_p4(1), 'b-', 'LineWidth', 1);
                hold off;
                xlabel('Time (s)');
                ylabel('X4 World Position (m)');
                axis([0, time_tol, -3, 20]);
            else
                hold on;
                set(thpx4, 'XData', [get(thpx4, 'XData'), time]);
                set(thpx4, 'YData', [get(thpx4, 'YData'), true_p4(1)]);
                set(ehpx4, 'XData', [get(ehpx4, 'XData'), time]);
                set(ehpx4, 'YData', [get(ehpx4, 'YData'), des_p4(1)]);
                hold off;
            end
    
            subplot(h32);
            axis([0, 20, -3, 10]);
            if ~vis_init
                hold on;
                thpy4 = plot(time, true_p4(2), 'r-', 'LineWidth', 1);
                ehpy4 = plot(time, des_p4(2), 'b-', 'LineWidth', 1);
                hold off;
                xlabel('Time (s)');
                ylabel('Y4 World Position (m)');
                axis([0, time_tol, -3, 3]);
            else
                hold on;
                set(thpy4, 'XData', [get(thpy4, 'XData'), time]);
                set(thpy4, 'YData', [get(thpy4, 'YData'), true_p4(2)]);
                set(ehpy4, 'XData', [get(ehpy4, 'XData'), time]);
                set(ehpy4, 'YData', [get(ehpy4, 'YData'), des_p4(2)]);
                hold off;
            end
            subplot(h33);
            if ~vis_init
                hold on;
                thpz4 = plot(time, true_p4(3), 'r-', 'LineWidth', 1);
                ehpz4 = plot(time, des_p4(3), 'b-', 'LineWidth', 1);
                hold off;
                xlabel('Time (s)');
                ylabel('Z4 World Position (m)');
                axis([0, time_tol, -3, 3]);
            else
                hold on;
                set(thpz4, 'XData', [get(thpz4, 'XData'), time]);
                set(thpz4, 'YData', [get(thpz4, 'YData'), true_p4(3)])
                set(ehpz4, 'XData', [get(ehpz4, 'XData'), time]);
                set(ehpz4, 'YData', [get(ehpz4, 'YData'), des_p4(3)]);
                hold off;
            end
    
            %% quadrotor 5
            subplot(h39);
            true_p5 = true_s(1:3, 5);
            des_p5 = s_des(1:3, 5);
            if ~vis_init
                hold on;
                thpx5 = plot(time, true_p5(1), 'r-', 'LineWidth', 1);
                ehpx5 = plot(time, des_p5(1), 'b-', 'LineWidth', 1);
                hold off;
                xlabel('Time (s)');
                ylabel('X5 World Position (m)');
                axis([0, time_tol, -3, 20]);
            else
                hold on;
                set(thpx5, 'XData', [get(thpx5, 'XData'), time]);
                set(thpx5, 'YData', [get(thpx5, 'YData'), true_p5(1)]);
                set(ehpx5, 'XData', [get(ehpx5, 'XData'), time]);
                set(ehpx5, 'YData', [get(ehpx5, 'YData'), des_p5(1)]);
                hold off;
            end
    
            subplot(h40);
            axis([0, 20, -3, 10]);
            if ~vis_init
                hold on;
                thpy5 = plot(time, true_p5(2), 'r-', 'LineWidth', 1);
                ehpy5 = plot(time, des_p5(2), 'b-', 'LineWidth', 1);
                hold off;
                xlabel('Time (s)');
                ylabel('Y5 World Position (m)');
                axis([0, time_tol, -3, 3]);
            else
                hold on;
                set(thpy5, 'XData', [get(thpy5, 'XData'), time]);
                set(thpy5, 'YData', [get(thpy5, 'YData'), true_p5(2)]);
                set(ehpy5, 'XData', [get(ehpy5, 'XData'), time]);
                set(ehpy5, 'YData', [get(ehpy5, 'YData'), des_p5(2)]);
                hold off;
            end
            subplot(h41);
            if ~vis_init
                hold on;
                thpz5 = plot(time, true_p5(3), 'r-', 'LineWidth', 1);
                ehpz5 = plot(time, des_p5(3), 'b-', 'LineWidth', 1);
                hold off;
                xlabel('Time (s)');
                ylabel('Z5 World Position (m)');
                axis([0, time_tol, -3, 3]);
            else
                hold on;
                set(thpz5, 'XData', [get(thpz5, 'XData'), time]);
                set(thpz5, 'YData', [get(thpz5, 'YData'), true_p5(3)])
                set(ehpz5, 'XData', [get(ehpz5, 'XData'), time]);
                set(ehpz5, 'YData', [get(ehpz5, 'YData'), des_p5(3)]);
                hold off;
            end
    
            %% quadrotor 6
            subplot(h47);
            true_p6 = true_s(1:3, 6);
            des_p6 = s_des(1:3, 6);
            if ~vis_init
                hold on;
                thpx6 = plot(time, true_p6(1), 'r-', 'LineWidth', 1);
                ehpx6 = plot(time, des_p6(1), 'b-', 'LineWidth', 1);
                hold off;
                xlabel('Time (s)');
                ylabel('X6 World Position (m)');
                axis([0, time_tol, -3, 20]);
            else
                hold on;
                set(thpx6, 'XData', [get(thpx6, 'XData'), time]);
                set(thpx6, 'YData', [get(thpx6, 'YData'), true_p6(1)]);
                set(ehpx6, 'XData', [get(ehpx6, 'XData'), time]);
                set(ehpx6, 'YData', [get(ehpx6, 'YData'), des_p6(1)]);
                hold off;
            end
    
            subplot(h48);
            axis([0, 20, -3, 10]);
            if ~vis_init
                hold on;
                thpy6 = plot(time, true_p6(2), 'r-', 'LineWidth', 1);
                ehpy6 = plot(time, des_p6(2), 'b-', 'LineWidth', 1);
                hold off;
                xlabel('Time (s)');
                ylabel('Y6 World Position (m)');
                axis([0, time_tol, -3, 3]);
            else
                hold on;
                set(thpy6, 'XData', [get(thpy6, 'XData'), time]);
                set(thpy6, 'YData', [get(thpy6, 'YData'), true_p6(2)]);
                set(ehpy6, 'XData', [get(ehpy6, 'XData'), time]);
                set(ehpy6, 'YData', [get(ehpy6, 'YData'), des_p6(2)]);
                hold off;
            end
            subplot(h49);
            if ~vis_init
                hold on;
                thpz6 = plot(time, true_p6(3), 'r-', 'LineWidth', 1);
                ehpz6 = plot(time, des_p6(3), 'b-', 'LineWidth', 1);
                hold off;
                xlabel('Time (s)');
                ylabel('Z6 World Position (m)');
                axis([0, time_tol, -3, 3]);
            else
                hold on;
                set(thpz6, 'XData', [get(thpz6, 'XData'), time]);
                set(thpz6, 'YData', [get(thpz6, 'YData'), true_p6(3)])
                set(ehpz6, 'XData', [get(ehpz6, 'XData'), time]);
                set(ehpz6, 'YData', [get(ehpz6, 'YData'), des_p6(3)]);
                hold off;
            end
        end
        %% Render
        drawnow;
        vis_time = time;
        vis_init = true;
    end
end
