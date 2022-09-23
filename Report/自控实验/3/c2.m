sys = tf(100,[1 5 0]);
sysc = feedback(sys,1);
step(sysc)