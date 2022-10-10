num = 40;
den = [1 2 0];
G0 = tf(num,den);
[Gm,Pm,Wcg,Wcp] = margin(G0);
w = 0.1:0.1:10000;
[mag,phase] = bode(G0,w);
magdb = 20*log10(mag);
phim1 = 35;
deta = 8;
phim = phim1-Pm+deta;
alpha = (1-sin(phim*pi/180))/(1+sin(phim*pi/180));
n = find(magdb+10*log10(1/alpha)<=0.0001);
wc = n(1);
w1 = (wc/10)*sqrt(alpha);
w2 = (wc/10)/sqrt(alpha);
numc = [1/w1,1];
denc = [1/w2,1];
Gc = tf(numc,denc);
G = Gc*G0;
[Gmc,Pmc,Wcgc,Wcpc] = margin(G);
GmcdB = 20*log10(Gmc);
disp('校正装置的传递函数和校正后系统的开环传递函数'),Gc,G,
disp('校正后系统的频域性能指标h，gama，wc'),[GmcdB,Pmc,Wcpc],
disp('校正装置的参数T和bita值'),T=1/w1;[T,alpha],
bode(G0,G);
hold on,margin(G)