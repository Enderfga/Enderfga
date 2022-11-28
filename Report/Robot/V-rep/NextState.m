function nextconf=NextState(current_conf,control,dt,max_speed)
% 参数：
% current_conf：当前状态，一个12维的状态向量，表达当前机器人的位形[𝜙, 𝑥, 𝑦, 𝐽1, 𝐽2, 𝐽3, 𝐽4, 𝐽5, 𝜃1, 𝜃2, 𝜃3, 𝜃4]
% control：控制量，一个9维的输入向量，控制机械臂关节速度和智能车轮子转速 [𝐽1̇ , 𝐽2̇ , 𝐽3̇ , 𝐽4̇ , 𝐽5̇ , 𝜃̇1, 𝜃̇2, 𝜃̇3, 𝜃̇4]
% dt：时间间隔
% max_speed：最大速度，超过这个速度按照饱和值计算
% 返回值：
% nextconf：下一个状态，一个12维的状态向量，表达dt后机器人的位形


l = 0.47/2; % 轴向距离
w = 0.3/2; % 径向距离
r = 0.0475; % 轮子半径

for i=1:9
    if max_speed == 0
        break
    end
    if  abs(control(i)) > max_speed
        control(i) = max_speed * sign(control(i));
    end
end

dtheta = control(6:9)*dt; % 轮子转动角度
dJ = control(1:5)*dt; % 关节转动角度
vb = r/4*[-1/(l+w),1/(l+w),1/(l+w),-1/(l+w);
        1,1,1,1;
        -1,1,-1,1]*dtheta'; % 轮子速度


if vb(1)==0
    dqb = [0;vb(2);vb(3)];
else
    dqb = [vb(1); 
          (vb(2)*sin(vb(1))+vb(3)*(cos(vb(1))-1))/vb(1);
          (vb(3)*sin(vb(1))-vb(2)*(cos(vb(1))-1))/vb(1)];
end
dq = [1,0,0;
    0,cos(current_conf(1)),-sin(current_conf(1));
    0,sin(current_conf(1)),cos(current_conf(1))]*dqb; % 机器人速度

nextconf(1:3) = current_conf(1:3)+dq'; % 机器人位形
nextconf(4:8) = current_conf(4:8)+dJ; % 关节角度
nextconf(9:12) = current_conf(9:12)+dtheta; % 轮子角度
end