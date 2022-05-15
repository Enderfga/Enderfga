
function xe = fkine_2DOF(l1, l2, q1, q2)

    s1 = sin(q1); c1 = cos(q1);
    s12 = sin(q1+q2); c12 = cos(q1+q2);
    
%     j11 = -l1*s1 - l2*s12;
%     j12 = -l2*s12;
%     j21 = l1*c1 + l2*c12;
%     j22 = l2*c12;
%     
%     Jaco_2DOF = [j11, j12;
%                  j21, j22];
%     
     pex = l1*c1 + l2*c12; 
     pey = l1*s1 + l2*s12;
     
     xe = [pex, pey]';

