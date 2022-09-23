num = 100;
i = 0;
for sigma = 0:0.25:1.25
    den=[1 2*sigma*10 100];
    damp(den)
    sys = tf(num,den);
    i = i+1;
    step(sys,2)
    hold on
end
grid
hold off
title('阻尼比\zeta取值不同时的阶跃响应曲线')
lab1 = '\zeta=0';text(0.3,1.9,lab1),
lab2 = '\zeta=0.25';text(0.3,1.5,lab2),
lab3 = '\zeta=0.5';text(0.3,1.2,lab3),
lab4 = '\zeta=0.75';text(0.3,1.05,lab4),
lab5 = '\zeta=1.0';text(0.35,0.9,lab5),
lab6 = '\zeta=1.25';text(0.35,0.8,lab6),