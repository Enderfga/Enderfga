% written by Shaojie Shen
% Feb 1, 2014
% 
% For details of this code see the paper:
% 
% S. Shen, Y. Mulgaonkar, N. Michael, and V. Kumar
% Initialization-free monocular visual-inertial estimation with application to autonomous MAVs
% International Symposium on Experimental Robotics (ISER), Marrakech, Morocco, June 2014.
% 
% For more info take a look at some of the papers posted here:
% 
% http://www.ee.ust.hk/~eeshaojie
%
% *** Internal Use Only - Do Not Distribute ***

function R = quaternion_to_R(q)
    
    q = q/norm(q); % Ensure Q has unit norm
    
    % Set up convenience variables
    w = q(1); x = q(2); y = q(3); z = q(4);
    w2 = w^2; x2 = x^2; y2 = y^2; z2 = z^2;
    xy = x*y; xz = x*z; yz = y*z;
    wx = w*x; wy = w*y; wz = w*z;
    
    R = [w2+x2-y2-z2 , 2*(xy - wz) , 2*(wy + xz) ; ...
         2*(wz + xy) , w2-x2+y2-z2 , 2*(yz - wx) ; ...
         2*(xz - wy) , 2*(wx + yz) , w2-x2-y2+z2];        
     
end
    
