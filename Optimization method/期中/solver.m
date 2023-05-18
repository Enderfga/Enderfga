% 利用最速梯度下降法求解函数的极小点

% 函数定义
f = @(x) 0.5*x(1)^2 + x(2)^2;

% 梯度定义
grad_f = @(x) [x(1); 2*x(2)];

% 初始值和收敛阈值
x0 = [2; 1];
epsilon = 1e-2;

% 最速梯度下降法
alpha = 0.1;  % 初始步长
x = x0;
grad = grad_f(x);
iter = 0;

while norm(grad) > epsilon
    % 计算步长
    % 这里可以使用线搜索方法来选择合适的步长 alpha，如 Armijo 规则或 Wolfe 条件
    
    % 更新变量
    x = x - alpha * grad;
    grad = grad_f(x);
    
    iter = iter + 1;
end

% 输出结果
fprintf('最小值点: (%f, %f)\n', x(1), x(2));
fprintf('迭代次数: %d\n', iter);

% 利用牛顿法求解函数的极小点

% 函数定义
f = @(x) 100*(x(2) - x(1)^2)^2 + (1 - x(1))^2;

% 梯度定义
grad_f = @(x) [-400*x(1)*(x(2) - x(1)^2) - 2*(1 - x(1));
                200*(x(2) - x(1)^2)];

% Hessian 矩阵定义
hessian = @(x) [1200*x(1)^2 - 400*x(2) + 2, -400*x(1);
                -400*x(1), 200];

% 初始值和收敛阈值
x0 = [-2; 2];
epsilon = 1e-2;

% 牛顿法
x = x0;
grad = grad_f(x);
iter = 0;

while norm(grad) > epsilon
    % 计算 Hessian 矩阵和其逆矩阵
    H = hessian(x);
    inv_H = inv(H);
    
    % 更新变量
    x = x - inv_H * grad;
    grad = grad_f(x);
    
    iter = iter + 1;
end

% 输出结果
fprintf('最小值点: (%f, %f)\n', x(1), x(2));
fprintf('迭代次数: %d\n', iter);

% 利用共轭梯度法求解方程组的根

% 原始方程组的系数矩阵 A
A = [4, -3; 2, 1];

% 原始方程组的右侧向量 b
b = [11; 13];

% 转化为对称正定矩阵 B = A^T * A
B = A' * A;

% 转化后的方程组的右侧向量
b_new = A' * b;

% 初始值和收敛阈值
x0 = [0; 0];
epsilon = 1e-6;

% 共轭梯度法
x = x0;
r = b_new - B * x;
p = r;
iter = 0;

while norm(r) > epsilon
    alpha = (r' * r) / (p' * B * p);
    x = x + alpha * p;
    r_new = r - alpha * B * p;
    beta = (r_new' * r_new) / (r' * r);
    p = r_new + beta * p;
    r = r_new;
    iter = iter + 1;
end

% 输出结果
fprintf('方程的根: (%f, %f)\n', x(1), x(2));
fprintf('迭代次数: %d\n', iter);

% 利用DFP算法求解函数的极小点

% 函数定义
f = @(x) x(1)^2 + 2*x(2)^2 - 4*x(1) - 2*x(1)*x(2);

% 梯度定义
grad_f = @(x) [2*x(1) - 4 - 2*x(2); 4*x(2) - 2*x(1)];

% 初始点和初始近似Hessian矩阵
x0 = [1; 1];
H0 = eye(2);

% 最大迭代次数和停止迭代的阈值
max_iter = 100;
epsilon = 1e-6;

% DFP算法
x = x0;
H = H0;
g = grad_f(x);
iter = 0;

while norm(g) > epsilon && iter < max_iter
    d = -H * g;  % 计算搜索方向
    
    % 使用线搜索方法选择合适的步长
    alpha = 1; % 这里可以使用固定步长或者其他线搜索方法
    
    x_new = x + alpha * d;
    g_new = grad_f(x_new);
    s = x_new - x;
    y = g_new - g;
    
    rho = 1 / (y' * s);
    H = (eye(2) - rho * s * y') * H * (eye(2) - rho * y * s') + rho * s * s'; % 更新近似Hessian矩阵
    
    x = x_new;
    g = g_new;
    iter = iter + 1;
end

% 输出结果
fprintf('最小值点: (%f, %f)\n', x(1), x(2));
fprintf('迭代次数: %d\n', iter);

