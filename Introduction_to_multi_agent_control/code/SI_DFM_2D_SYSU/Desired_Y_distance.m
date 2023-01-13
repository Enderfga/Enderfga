%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function defines the desired, time-varying distances and their
% derivative
% Input variables: time t, number of agents n, and Adjacency matrix Adj
% Output variables: desired distance vector d(t) and derivative d_dot(t)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [d,d_dot] = Desired_Y_distance(t,n,Adj)

% Calculation of d(t)
A = 0.5;                    % Amplitude of AC component of desired distance
w = 1.3;                    % Frequency of AC component of desired distance 
AC = 0.5;
% x_coor = [-(AC)/2; AC/2; AC/4;0;0;-AC/4];
% % y coordinate of framework F*(t) 
% y_coor = [cos(pi/3)*AC/2; cos(pi/3)*AC/2; 0;-cos(pi/3)*AC/2; -cos(pi/3)*AC*4 ;0 ];
%x_coor = [-(AC); AC; 0;0;0;0];
x_coor = [-0.12*1.5;0.1*1.5;0;0;0;0];
% y coordinate of framework F*(t) 
%y_coor = [cos(pi/6)*AC + AC/2; cos(pi/6)*AC + AC/2; AC/2;0; -AC ;-AC/2 ];
y_coor = [0.35;0.45;0.04226*5;-0.1*5;-0.05258*5;-0.00516*5];

q_star2 = [x_coor'; y_coor'];        % 2xn vector

d = zeros(n,n);                      % initialize the desired distance
d_dot = zeros(2*n-3,1);

for i = 1:n
    for j = 1:n
        d(i,j) = sqrt((x_coor(i)-x_coor(j))^2 + (y_coor(i)-y_coor(j))^2);
    end
end

% Calculation of d_dot(t)
ACdot = 0 ;
 

x_coor_dot = [-(ACdot); ACdot; 0; 0;0;0];
y_coor_dot = [cos(pi/6)*ACdot + ACdot/2; cos(pi/6)*ACdot+ACdot/2 ;ACdot/2; 0; -ACdot; -ACdot/2 ];  



q_dot_star2 = [x_coor_dot'; y_coor_dot'];  % 2xn vector

for i = 1:n-1
    for j = i+1:n
        if Adj(i,j) == 1
            d_dot(i,j) = (q_star2(:,i)-q_star2(:,j))'...
                          *(q_dot_star2(:,i)-q_dot_star2(:,j))/d(i,j);
        end
    end
end