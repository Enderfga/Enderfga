sigma = 0.25;
i = 0;
for wn = 10:20:50
    num = wn^2;
    den = [1,2*sigma*wn,wn^2];
    sys = tf(num,den);
    i = i+1;
    step(sys,2)
    hold on
    grid
end
hold off
title('\omega_n变化时系统的阶跃响应曲线')
lab1 = '\omega_n=10';text(0.35,1.4,lab1),
lab2 = '\omega_n=30';text(0.12,1.3,lab2),
lab3 = '\omega_n=50';text(0.05,1.2,lab3),