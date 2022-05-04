%Patient Model
p=2;
ng= [ 1 ] ; dg= [ 1 2*p p^2] ;
%PD Controller+pump model : Gc(s) Gp(s)
K1=10;K2=10; %PD gains
dc= [ 1 0 0 ] ;
nc= [K2 K1 ] ;
%Closed-loop transfer functions from disturbance to output
[ num, den]=feedback (ng , dg, nc , dc) ;

%step Responses
tf=20 ; %maximum time for settling
t=[ 0 :0.1:tf ] ;
Do=50 ; %Do is the disturbance magnitude
yc=step (-Do*num, den,t) ;
%Generate step response plots
plot (t, yc)
grid
ylabel ( 'Percent decrease in mean arterial pressure (%) ')
xlabel ( ' Time (min) ' )
title ( 'Mean arterial pressure (MAP) disturbance step response. ' )
