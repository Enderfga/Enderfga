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

function ypr = R_to_ypr(R)

    n = R(:,1);
    o = R(:,2);
    a = R(:,3);
    
    y = atan2(n(2), n(1));
    p = atan2(-n(3), n(1)*cos(y)+n(2)*sin(y));
    r = atan2(a(1)*sin(y)-a(2)*cos(y), -o(1)*sin(y)+o(2)*cos(y));
    ypr = [y;p;r];

end
