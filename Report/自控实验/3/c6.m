num1 = 10;
den = [1 2 10];
G0 = tf(num1,den);
step(G0),hold on
num2 = [2 10];
G1 = tf(num2,den);
step(G1),hold on
num3 = [5 10];
G2 = tf(num3,den);
step(G2),hold on
num4 = [10 10];
G3 = tf(num4,den);
step(G3),hold on
hold off
grid on
