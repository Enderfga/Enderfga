function [ys,tr,ts,tm,ov] = Fun_Step_Performance(t,y,drawflag)
% [ys,tr,ts,ov] = Fun_Step_Performance(t,y) 标准阶跃响应的性能指标求解
% 本程序适用于标准阶跃响应曲线，末尾时间必须已经接近稳态值
% t-y 为阶跃响应的时间-输出配对序列，可由[y,t] = step(sys)求得
% drawflag为时候作图标志，不输入或输入非0值时，默认作图，输入0时不做图
% ys 稳态值
% tr 上升时间，默认为0-90%的上升时间
% ts 调整时间，默认为2%的调整时间
% tm 为峰值时间
% ov 超调量 %
% e.g.
%  sys = tf(1,[1 2*0.5*1 1]);
%  [y,t] = step(sys,15);
%  [ys,tr,ts,tm,ov] = Fun_Step_Performance(t,y,1);
% By ZFS@wust  2020
% 获取更多Matlab/Simulink原创资料和程序，清关注微信公众号：Matlab Fans


if nargin == 2
    drawflag = 1;   % 默认绘图
end

ys = y(end);         % 稳态增益
[ym, ind] = max(y);  % 最大输出
ov = 100*(ym-ys)/ys; % 超调量
tm = t(ind);         % 峰值时间
ind2 = length(t);
delta = 0.02;        % 调整时间默认范围2%
while t(ind2) > 0
    if abs(y(ind2)-ys) >= delta*ys
        break
    end
    ind2 =  ind2-1;
end
ts = t(ind2);          % 调整时间
ind3 = 1;
while y(ind3) < 0.9*ys
    ind3 = ind3 + 1;
end
tr = t(ind3);          % 上升时间

if drawflag ~= 0
    figure
    plot(t,y)
    hold on
    plot([tr tr],[0 0.9*ys],'k:')
    plot([tm tm],[0 ym],'k:')
    plot([ts ts],[0 (1-delta)*ys],'k:')
    plot([t(1) t(end)],[ys ys],'k-.')
    xlabel('时间/s')
    ylabel('输出')
    title('阶跃响应曲线')
    text(1.1*tr,0.2*ys,['上升时间：' num2str(tr)  's'])
    text(1.1*ts,0.6*ys,['调整时间：' num2str(ts)  's'])
    if  abs(tm-t(end)) > 0.1*tm
        text(1.1*tm,1*ym,['峰值时间：' num2str(tm)  's，超调量：' num2str(ov) '%'])
    else
        text(0.55*tm,0.8*ym,['峰值时间：' num2str(tm)  's，超调量：' num2str(ov) '%'])
    end
    text(0.7*t(end),0.95*ys,['稳态值：' num2str(ys,3)])
    disp('%% 阶跃响应指标结果：')
    disp(['上升时间：' num2str(tr)  's'])
    disp(['调整时间：' num2str(ts)  's'])
    disp(['峰值时间：' num2str(tm)  's，超调量：' num2str(ov) '%'])
    disp(['稳态值：' num2str(ys,3)])
    disp('%% 阶跃响应指标结果显示结束')
end