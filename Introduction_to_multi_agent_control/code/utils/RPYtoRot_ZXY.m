function R = RPYtoRot_ZXY(phi,theta,psi)
%written by Daniel Mellinger

% BRW = [ cos(psi)*cos(theta) - sin(phi)*sin(psi)*sin(theta), 
%     cos(theta)*sin(psi) + cos(psi)*sin(phi)*sin(theta), -cos(phi)*sin(theta)]
% 
% [                                 -cos(phi)*sin(psi),
%     cos(phi)*cos(psi),             sin(phi)]
% 
% [ cos(psi)*sin(theta) + cos(theta)*sin(phi)*sin(psi), 
%     sin(psi)*sin(theta) - cos(psi)*cos(theta)*sin(phi),
%     cos(phi)*cos(theta)]

R = [ cos(psi)*cos(theta) - sin(phi)*sin(psi)*sin(theta),... 
    cos(theta)*sin(psi) + cos(psi)*sin(phi)*sin(theta), -cos(phi)*sin(theta);...
    -cos(phi)*sin(psi),...
    cos(phi)*cos(psi),             sin(phi);...
    cos(psi)*sin(theta) + cos(theta)*sin(phi)*sin(psi),...
    sin(psi)*sin(theta) - cos(psi)*cos(theta)*sin(phi),...
    cos(phi)*cos(theta)];
