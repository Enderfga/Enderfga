ModelParams.Scale=1;%scale of the car (1 is a 1:43 scale car)
ModelParams.sx=7; %number of states
ModelParams.su=3; %number of inputs
ModelParams.nx=7; %number of states
ModelParams.nu=3; %number of inputs

ModelParams.stateindex_x=1; %x position
ModelParams.stateindex_y=2; %y position
ModelParams.stateindex_phi=3; %orientation
ModelParams.stateindex_vx=4; %longitudinal velocity
ModelParams.stateindex_vy=5; %lateral velocity
ModelParams.stateindex_omega=6; %yaw rate
ModelParams.stateindex_theta=7; %virtual position

ModelParams.inputindex_D=1; %duty cycle
ModelParams.inputindex_delta=2; %steering angle
ModelParams.inputindex_vtheta=3; %virtual speed

ModelParams.m = 0.041;
ModelParams.Iz = 27.8e-6;
ModelParams.lf = 0.029;
ModelParams.lr = 0.033;

ModelParams.Cm1=0.287;
ModelParams.Cm2=0.0545;
ModelParams.Cr0=0.0218;
ModelParams.Cr2=0.00035;

ModelParams.Br = 3.3852;
ModelParams.Cr = 1.2691;
ModelParams.Dr = 0.1737;

ModelParams.Bf = 2.579;
ModelParams.Cf = 1.2;
ModelParams.Df = 0.192;

ModelParams.L = 0.12;
ModelParams.W = 0.06;
ModelParams.WheelD = 0.02;