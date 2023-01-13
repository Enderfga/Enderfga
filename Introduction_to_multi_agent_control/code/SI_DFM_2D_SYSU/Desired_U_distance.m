%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function defines the desired, time-varying distances and their
% derivative
% Input variables: time t, number of agents n, and Adjacency matrix Adj
% Output variables: desired distance vector d(t) and derivative d_dot(t)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [d,d_dot] = Desired_U_distance(t,n,Adj)                  
% AC = 1;      % AC component of desired distances
% x_coor = [-AC/2; AC/2; AC/2;AC/4; -AC/4; -AC/2];
% y_coor = [AC/2; AC/2; -AC/2;-AC/2; -AC/2; -AC/2];
x_coor = [-0.2;0.3;-0.2;-0.05*2.5;0.06*2.5;0.3];
y_coor = [-0.4*4;-0.4*4;-0.8*2.5;-0.8*3;-0.8*3;-0.8*2.5];
q_star2 = [x_coor'; y_coor'];        % 2xn vector

d = zeros(n,n);                      % initialize the desired distance
d_dot = zeros(2*n-3,1);

for i = 1:n
    for j = 1:n
        d(i,j) = sqrt((x_coor(i)-x_coor(j))^2 + (y_coor(i)-y_coor(j))^2);
    end
end


ACdot = 0 ;

x_coor_dot = [-ACdot/2; ACdot/2; ACdot/2; ACdot/4; -ACdot/4; -ACdot/2];
y_coor_dot = [ACdot/2; ACdot/2; -ACdot/2; -ACdot/2; -ACdot/2; -ACdot/2];     
q_dot_star2 = [x_coor_dot'; y_coor_dot'];  % 2xn vector

for i = 1:n-1
    for j = i+1:n
        if Adj(i,j) == 1
            d_dot(i,j) = (q_star2(:,i)-q_star2(:,j))'...
                          *(q_dot_star2(:,i)-q_dot_star2(:,j))/d(i,j);
        end
    end
end