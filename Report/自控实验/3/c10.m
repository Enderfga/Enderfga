num = [1 1];
den = [1 1 1];
G = tf(num,den);
t = [0:0.1:20];
u = 1+1*t;
lsim(G,u,t)
hold on
plot(t,u,'r');
grid on