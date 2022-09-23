num = 10;
den = [1 2 10];
roots(den);
sys = tf(num,den);
eig(sys);
damp(den);
step(sys)