function [control,Xerr]=FeedbackControl(X, Xd, Xdnext, Kp, Ki, dt,thetalist)

Vd = se3ToVec(1/dt*MatrixLog6(Xd\Xdnext));
AdXinvXdVd = Adjoint(X\Xd)*Vd;
Xerr = se3ToVec(MatrixLog6(X\Xd));
V = AdXinvXdVd + Kp*Xerr + Ki*(Xerr*dt);
Blist = [[0; 0; 1; 0; 0.033; 0],...
        [0; -1; 0; -0.5076; 0; 0],...
        [0; -1; 0; -0.3526; 0; 0],...
        [0; -1; 0; -0.2176; 0; 0],...
        [0; 0; 1; 0; 0; 0]];
%thetalist = [0; 0; 0.2; -1.6; 0];
Jarm = JacobianBody(Blist, thetalist);
Tb0 = [ 1 0 0 0.1662;
        0 1 0 0;
        0 0 1 0.0026;
        0 0 0 1];
T0b = inv(Tb0);
M0e = [ 1 0 0 0.033;
        0 1 0 0;
        0 0 1 0.6546;
        0 0 0 1];
T0e = FKinBody(M0e, Blist, thetalist);
Te0 = inv(T0e);
r = 0.0475; % radius of whell
l = 0.47/2; % L的小写l，与下面的1作区分
w = 0.3/2; % w
F6 = [ 0 0 0 0 ;
        0 0 0 0 ;
        -1/(l+w) 1/(l+w) 1/(l+w) -1/(l+w);
        1 1 1 1 ;
        -1 1 -1 1 ;
        0 0 0 0 ;]*r/4;
Jbase = Adjoint(Te0*T0b)*F6;
%Jbase = Adjoint(T0e/T0b)*F6;
Je = [Jbase Jarm];
control = pinv(Je)*V;
end