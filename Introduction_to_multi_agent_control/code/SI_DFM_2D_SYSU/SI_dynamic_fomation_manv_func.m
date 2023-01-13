%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function is for dynamic formation maneuvering of single integrator 
% model.
% Input variables: t as time sequence; q_vec as vector of q,
%                  para is the structured parameters passing from the main
% Output variable: dq is the time derivative of q
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ u ] = SI_dynamic_fomation_manv_func( t,q_vec,para,Adj,character)
% Obtain parameters from structure para
n = para.n;
kv = para.kv;
Adj = para.Adj;

% Obtain q from vector q_vec such that
% q(:,i) indicates the coordinate of the ith agent
q = reshape(q_vec,2,[]);    % 2xn vector
%
z = zeros(2*n-3,1);         % initialize z
R = zeros(2*n-3,2*n);       % initialize Rigidity Matrix
e = zeros(n,n);             % Distance error matrix
dv = zeros(2*n-3,1);

%% Choose a formation based on letters
switch (character)
    case 'Y'
        [d,d_dot] = Desired_Y_distance(t,n,Adj);
    case 'S'
        [d,d_dot] = Desired_S_distance(t,n,Adj);
    case 'U'
        [d,d_dot] = Desired_U_distance(t,n,Adj);

end
ord = 1;
for i = 1:n-1
    for j = i+1:n
        e(i,j) = sqrt((q(:,i)-q(:,j))'*(q(:,i)-q(:,j)))-d(i,j);
        if Adj(i,j) == 1
            dv(ord) = d(i,j)*d_dot(i,j);
            z(ord) = e(i,j)*(e(i,j)+2*d(i,j));
            R(ord,2*i-1:2*i) = (q(:,i)-q(:,j))';
            R(ord,2*j-1:2*j) = (q(:,j)-q(:,i))';
            ord = ord+1;
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vd = Desired_velocity(t);     % desired velocity
% u = -kv*R'*z+kron(ones(n,1),vd);   
% u= R'*pinv(R*R')*(-kv*z + 0);
 u = R'*pinv(R*R')*(-kv*z + dv)+kron(ones(n,1),vd);  % control input
 dq = u;