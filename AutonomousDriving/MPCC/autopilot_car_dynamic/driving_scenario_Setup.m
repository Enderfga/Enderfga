%% Vehicle Parameters
wheelbase = 2.8;         % Wheelbase of the vehicle (m)

%% General Model Parameters
Ts = 0.05;               % Simulation sample time (s) 

%% Create scenario and road specifications
[scenario, egoVehicle] = driving_scenario;

% You can use Driving Scenario Designer to explore the scenario
% drivingScenarioDesigner('LateralControl')

%% Generate data for Simulink simulation  
[refPoses,x0,y0,theta0,curvatures,cumLengths, simStopTime] = helperCreateReferencePath(scenario);

directions   = ones(size(refPoses, 1), 1);
speedProfile = ones(size(refPoses, 1), 1)*speed;

%% Bus Creation
% Create the bus of actors from the scenario reader
modelName = 'LateralControlTutorial';
wasModelLoaded = bdIsLoaded(modelName);
if ~wasModelLoaded
    load_system(modelName)
end

% Create buses for lane sensor and lane sensor boundaries
helperCreateLaneSensorBuses;

% load the bus for scenario reader
% blk=find_system(modelName,'System','driving.scenario.internal.ScenarioReader');
% s = get_param(blk{1},'PortHandles');
% get(s.Outport(1),'SignalHierarchy');