
%----2DOF机械臂求解函数
%---输入：
%-------pex: 机械臂末端相对于根部的位置, x分量
%-------pey: 机械臂末端相对于根部的位置, y分量
%-------qr： 参考关节角
%-------l1、l2：臂杆长度

%---输出：
%------ theta = [theta1, theta2]---两个关节角
function theta = ikine_2DOF_fcn(pex, pey, qr, l1, l2)

% clear
% clc
% 
% l1 = 2; 
% l2 = 2;

q10 = qr(1);
q20 = qr(2);

% c0 = [0.2, 0.2];
% R = sqrt((l1*cos(q10) + l2*cos(q10 + q20))^2 + (l1*sin(q10) + l2*sin(q10 + q20))^2 );
% 
% phi = 0*pi/180;
% pex = c0(1) + R*cos(phi);
% pey = c0(2) +R*sin(phi);


  ll = (pex^2 + pey^2 - l1^2 -l2^2)/(2*l1*l2);
  if (ll<=1)    %----判断如果有有效解，正常解算
      q2(1) = acos(ll);
      q2(2) = -q2(1);
      for i = 1:2
        c2 = cos(q2(i));
        s2 = sin(q2(i));

        a11 = l1 + l2*c2;
        a12 = -l2*s2;
        a21 = l2*s2;
        a22 = l1 + l2*c2;
        A = [a11, a12; a21, a22];

        c1s1 = inv(A)*[pex; pey];
        c1 = c1s1(1);
        s1 = c1s1(2);
        q1(i) = atan2(s1, c1);
        
        %----限制到[-pi, pi];
            while (q1(i)<-pi)
                q1(i) = q1(i)+2*pi;
            end

            while (q1(i)>pi)
                q1(i) = q1(i)-2*pi;
            end

            while (q2(i)<-pi)
                q2(i) = q2(i)+2*pi;
            end

            while (q2(i)>pi)
                q2(i) = q2(i)-2*pi;
            end
    %     pex_p(i) = l1*cos(q1(i)) + l2*cos(q1(i) + q2(i));
    %     pey_p(i) = l1*sin(q1(i)) + l2*sin(q1(i) + q2(i));
    end
      m = abs(q1(1) - q10) + abs(q2(1) - q20) ;
      n = abs(q1(2) - q10) + abs(q2(2) - q20) ;

      if m<n
          theta1 = q1(1);
          theta2 = q2(1);
      else
          theta1 = q1(2);
          theta2 = q2(2);
      end
  else   %----否则，将参考值返回
      theta1 = q10;
      theta2 = q20;
  end
      
  
  theta = [theta1 theta2];
%   pex_p = l1*cos(theta(1)) + l2*cos(theta(1) + theta(2));
%   pey_p = l1*sin(theta(1)) + l2*sin(theta(1) + theta(2));
% %   pex_p = l1*cos(theta(1)) + l2*cos(theta(1) + theta(2));
% %   pey_p = l1*sin(theta(1)) + l2*sin(theta(1) + theta(2));
%   
% %   pex_p = l1*cos(q1(1)) + l2*cos(q1(1) + q1(2));
% %   pey_p = l1*sin(q1(1)) + l2*sin(q1(1) + q1(2));
% %   
%    err = [pex_p pey_p] - [pex pey]
      
  


    
    


