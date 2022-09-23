num = 100;
den = [1 3 0];
G = tf(num,den);
Gc = feedback(G,1);
step(Gc)