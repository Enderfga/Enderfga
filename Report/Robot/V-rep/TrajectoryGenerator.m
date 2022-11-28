function result_traj = TrajectoryGenerator(Tseinitial, Tscinitial,Tscfinal, Tcegrasp, Tcestandoff, k)
% 参数：
% Tseinitial 爪子的初始位形
% Tscinitial 物块的初始位形
% Tscfinal 物块的最终位形
% Tcegrasp 抓取时的末端位形
% Tcestandoff 抓取后的末端位形
% k 每秒参考轨迹位形数目
% 返回值：
% result_traj 生成的参考轨迹
flag = 0;
Xstart = Tseinitial;
Xend = Tscinitial*Tcestandoff;
Tf = 100;
N = k;
method = 5;
traj = ScrewTrajectory(Xstart, Xend, Tf, N, method);
result_traj = [];
for i = 1:k
    traj_ = cell2mat(traj(i));
    result = [traj_(1),traj_(5),traj_(9),traj_(2),traj_(6),traj_(10),traj_(3),traj_(7),traj_(11),traj_(13),traj_(14),traj_(15),flag];
    result_traj = [result_traj;result];
end
Xstart = Tscinitial*Tcestandoff;
Xend = Tscinitial*Tcegrasp;
traj = ScrewTrajectory(Xstart, Xend, Tf, N, method);
for i = 1:k
    traj_ = cell2mat(traj(i));
    result = [traj_(1),traj_(5),traj_(9),traj_(2),traj_(6),traj_(10),traj_(3),traj_(7),traj_(11),traj_(13),traj_(14),traj_(15),flag];
    result_traj = [result_traj;result];
end
flag = 1;
traj_ = cell2mat(traj(k));
result = [traj_(1),traj_(5),traj_(9),traj_(2),traj_(6),traj_(10),traj_(3),traj_(7),traj_(11),traj_(13),traj_(14),traj_(15),flag];
for j = 1:k
    result_traj = [result_traj;result(1:12),flag];
end
Xstart = Tscinitial*Tcegrasp;
Xend = Tscinitial*Tcestandoff;
traj = ScrewTrajectory(Xstart, Xend, Tf, N, method);
for i = 1:k
    traj_ = cell2mat(traj(i));
    result = [traj_(1),traj_(5),traj_(9),traj_(2),traj_(6),traj_(10),traj_(3),traj_(7),traj_(11),traj_(13),traj_(14),traj_(15),flag];
    result_traj = [result_traj;result];
end
Xstart = Tscinitial*Tcestandoff;
Xend = Tscfinal*Tcestandoff;
traj = ScrewTrajectory(Xstart, Xend, Tf, N, method);
for i = 1:k
    traj_ = cell2mat(traj(i));
    result = [traj_(1),traj_(5),traj_(9),traj_(2),traj_(6),traj_(10),traj_(3),traj_(7),traj_(11),traj_(13),traj_(14),traj_(15),flag];
    result_traj = [result_traj;result];
end
Xstart = Tscfinal*Tcestandoff;
Xend = Tscfinal*Tcegrasp;
traj = ScrewTrajectory(Xstart, Xend, Tf, N, method);
for i = 1:k
    traj_ = cell2mat(traj(i));
    result = [traj_(1),traj_(5),traj_(9),traj_(2),traj_(6),traj_(10),traj_(3),traj_(7),traj_(11),traj_(13),traj_(14),traj_(15),flag];
    result_traj = [result_traj;result];
end
flag = 0;
traj_ = cell2mat(traj(k));
result = [traj_(1),traj_(5),traj_(9),traj_(2),traj_(6),traj_(10),traj_(3),traj_(7),traj_(11),traj_(13),traj_(14),traj_(15),flag];
for j = 1:k
    result_traj = [result_traj;result(1:12),flag];
end
Xstart = Tscfinal*Tcegrasp;
Xend = Tscfinal*Tcestandoff;
traj = ScrewTrajectory(Xstart, Xend, Tf, N, method);
for i = 1:k
    traj_ = cell2mat(traj(i));
    result = [traj_(1),traj_(5),traj_(9),traj_(2),traj_(6),traj_(10),traj_(3),traj_(7),traj_(11),traj_(13),traj_(14),traj_(15),flag];
    result_traj = [result_traj;result];
end
end