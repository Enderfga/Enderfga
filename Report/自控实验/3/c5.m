num = 10;
den = [1 2 10];
G = tf(num,den);
t = [0:0.1:20];
u = 5+2*t+8*t.^2;
lsim(G,u,t)
hold on
plot(t,u,'r');
grid on