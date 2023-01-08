% 4.1
%drivingScenarioDesigner('4.1.mat')

% 4.2
%clc,clear
% 创建仿真场景
scenario = drivingScenario;

% 添加道路
roadCenters = [0 20 0;
0 -20 0];
laneSpecification = lanespec(2);
road(scenario, roadCenters, 'Lanes', laneSpecification, 'Name', 'Road');

roadCenters = [3.6 0 0;
-30 0 0];
laneSpecification = lanespec(2);
road(scenario, roadCenters, 'Lanes', laneSpecification, 'Name', 'Road1');

% 绘制场景，plot第一张图
% figure(1)
% plot(scenario)
% xlim([-30 3.6])
% ylim([-20 20])



% 添加小车
egoVehicle = vehicle(scenario, ...
'ClassID', 1, ...
'Position', [-28.75 -1.7 0.01], ...
'Mesh', driving.scenario.carMesh, ...
'Name', 'Car1');
waypoints = [-28.75 -1.7 0.01;
-2.88 -1.7 0.01;
1.71 3.99 0.01;
1.95 18.56 0.01];
speed = [30;15;15;30];
yaw = [0;0;90;90];
trajectory(egoVehicle, waypoints, speed, 'Yaw', yaw);

car2 = vehicle(scenario, ...
'ClassID', 1, ...
'Position', [2.18 -18.76 0.01], ...
'Mesh', driving.scenario.carMesh, ...
'Name', 'Car2');
waypoints = [2.18 -18.76 0.01;
1.87 -2.56 0.01;
-2.73 1.57 0.01;
-28.59 1.89 0.01];
speed = [30;15;15;30];
yaw = [90;90;-180;-180];
% 绘制小车，plot第二张图
% figure(2)
% plot(scenario)
% xlim([-30 3.6])
% ylim([-20 20])


trajectory(car2, waypoints, speed, 'Yaw', yaw);

% 仿真轨迹
% scenario.StopTime = 4;
% while advance(scenario)
%   pause(0.001)
% end
close all;
hFigure = figure;
hFigure.Position(3) = 900;

hPanel1 = uipanel(hFigure,'Units','Normalized','Position',[0 1/4 1/2 3/4],'Title','Scenario Plot');
hPanel2 = uipanel(hFigure,'Units','Normalized','Position',[0 0 1/2 1/4],'Title','Chase Plot');
hPanel3 = uipanel(hFigure,'Units','Normalized','Position',[1/2 0 1/2 1],'Title','Bird''s-Eye Plot');

hAxes1 = axes('Parent',hPanel1);
hAxes2 = axes('Parent',hPanel2);
hAxes3 = axes('Parent',hPanel3);
% assign scenario plot to first axes and add indicators for ActorIDs 1 and 2
plot(scenario, 'Parent', hAxes1,'ActorIndicators',[1 2]);

% assign chase plot to second axes
chasePlot(egoVehicle, 'Parent', hAxes2);

% assign bird's-eye plot to third axes
egoCarBEP = birdsEyePlot('Parent',hAxes3,'XLimits',[-200 200],'YLimits',[-240 240]);
fastTrackPlotter = trackPlotter(egoCarBEP,'MarkerEdgeColor','red','DisplayName','target','VelocityScaling',.5);
egoTrackPlotter = trackPlotter(egoCarBEP,'MarkerEdgeColor','blue','DisplayName','ego','VelocityScaling',.5);
egoLanePlotter = laneBoundaryPlotter(egoCarBEP);
plotTrack(egoTrackPlotter, [0 0]);
egoOutlinePlotter = outlinePlotter(egoCarBEP);

restart(scenario)
scenario.StopTime = Inf;

while advance(scenario)
    t = targetPoses(egoVehicle);
    plotTrack(fastTrackPlotter, t.Position, t.Velocity);
    rbs = roadBoundaries(egoVehicle);
    plotLaneBoundary(egoLanePlotter, rbs);
    [position, yaw, length, width, originOffset, color] = targetOutlines(egoVehicle);
    plotOutline(egoOutlinePlotter, position, yaw, length, width, 'OriginOffset', originOffset, 'Color', color);
end
% drivingScenarioDesigner(scenario)