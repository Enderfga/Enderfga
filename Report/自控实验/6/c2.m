num = 10;
den = conv([1,0],conv([0.5,1],[1/30,1]));
G0 = tf(num,den);
[Gm,Pm,Wcg,Wcp] = margin(G0);
w = 0.1:1:10000;
[mag,phase] = bode(G0,w);
magdb = 20*log10(mag);
phim1 = 50.9593;
deta = 18.54;
phim = (phim1-Pm+deta);
alpha = (1+sin(phim*pi/180))/(1-sin(phim*pi/180));
n = find(magdb+10*log10(alpha)<=0.0001);
wc = n(1)+0.1;
w1 = wc/sqrt(alpha);
w2 = wc*sqrt(alpha);
numc = (1/alpha)*[1/w1,1];
denc = [1/w2,1];
Gc = tf(numc,denc);
G = (alpha)*Gc*G0;
disp('显示校正网络传递函数及alpha，T的值'),T=1/w2;Gc,[alpha,T],
bode(G0,G);
hold on,margin(G),figure(2);
sys0 = feedback(G0,1);step(sys0);hold on,
sys = feedback(G,1);step(sys)