%% 第一题
% 定义目标函数
fun = @(x) x(1)^2 + x(2)^2;

% 定义约束条件
A = []; b = []; % 无线性不等式约束
Aeq = [1 1]; beq = 1; % 线性等式约束 x1 + x2 = 1
lb = [-Inf, -Inf]; ub = [Inf, 1/4]; % x2 <= 1/4

% 定义初始值
x0 = [0, 0];

% 调用 fmincon 函数求解
options = optimoptions('fmincon','Display','iter','Algorithm','interior-point');
[x,fval] = fmincon(fun, x0, A, b, Aeq, beq, lb, ub, [], options);

% 输出结果
disp('The solution is:'), disp(x)
disp('The minimum value of the objective function is:'), disp(fval)

%% 第二题
% 定义目标函数和罚函数
fun = @(x) x(1)^2 + x(2)^2 + x(3)^2;
g = @(x) abs(x(1) + 2*x(2) - x(3) - 4) + abs(x(1) - x(2) + x(3) + 2);
P = @(x, r) fun(x) + r * g(x);

% 定义初始值和罚项权重
x0 = [0, 0, 0];
r = 1;

% 使用 fminunc 函数求解
options = optimoptions('fminunc','Display','iter','Algorithm','quasi-newton');
[x,fval] = fminunc(@(x) P(x, r), x0, options);

% 输出结果
disp('The solution is:'), disp(x)
disp('The minimum value of the objective function is:'), disp(fval)

%% 第三题
% 定义目标函数
fun = @(x) -(x + 5*sin(5*x) + 10*cos(4*x)); % 注意我们取负值，因为MATLAB的遗传算法默认是求最小值

% 定义遗传算法的参数
numberOfVariables = 1; 

% 定义约束上下界
lb = 0; 
ub = 10;

% 使用 ga 函数求解
[x,fval] = ga(fun,numberOfVariables,[],[],[],[],lb,ub);

% 输出结果
disp('The solution is:'), disp(x)
disp('The maximum value of the objective function is:'), disp(-fval)

%% 第四题
% 定义目标函数和罚函数
fun = @(x) x(1)^2 + x(2)^2;
g = @(x) x(1) - 2;
P = @(x, r) fun(x) - r * log(g(x));

% 定义初始值和罚项权重
x0 = [3, 0]; % 初始值需要满足约束条件
r = 0.0001;

% 使用 fminunc 函数求解
options = optimoptions('fminunc','Display','iter','Algorithm','quasi-newton');
[x,fval] = fminunc(@(x) P(x, r), x0, options);

% 输出结果
disp('The solution is:'), disp(x)
disp('The minimum value of the objective function is:'), disp(fval)

%% 第五题
% 定义目标函数
fun = @(x) sum(x.^2);

% 定义参数
alphas = [0.001,0.1,0.5, 1, 2, 5]; % 邻域大小
T = 100; % 初始温度
T_min = 1e-3; % 最小温度
cooling_rate = 0.95; % 冷却率
max_iter = 100; % 每个温度下的最大迭代次数

% 定义约束条件
lb = -15 * ones(1, 10); % 下界
ub = 15 * ones(1, 10); % 上界

results = zeros(length(alphas), 2);

for a = 1:length(alphas)
    % 初始化解
    x = lb + (ub - lb) .* rand(1, 10);
    alpha = alphas(a);

    T_current = T;
    while T_current > T_min
        for i = 1:max_iter
            % 在邻域中随机生成新解
            x_new = x + alpha * (2*rand(1, 10) - 1);
            x_new = max(min(x_new, ub), lb); % 确保新解满足约束条件

            % 计算目标函数的改变量
            delta_f = fun(x_new) - fun(x);

            % 如果新解更好，或者满足 Metropolis 准则，则接受新解
            if delta_f < 0 || rand() < exp(-delta_f / T_current)
                x = x_new;
            end
        end

        % 降低温度
        T_current = cooling_rate * T_current;
    end

    % 记录结果
    results(a, :) = [alpha, fun(x)];

    % 输出结果
    fprintf('For alpha = %f:\n', alpha);
    disp('The solution is:'), disp(x)
    disp('The minimum value of the objective function is:'), disp(fun(x))
end

% 可视化结果
figure;
semilogy(results(:, 1), results(:, 2), '-o', 'Color', [0.2 0.4 0.6], 'LineWidth', 2, 'MarkerSize', 8);
xlabel('Alpha');
ylabel('Minimum Value of Objective Function');
title('Impact of Alpha on the Solution');


