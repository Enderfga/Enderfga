%Patient Model
p=2;
ng= [ 1 ] ; dg= [ 1 2*p p^2 0 ] ;
%Closed-loop transfer functions from disturbance to output
[ num, den ] =feedback (ng, dg, 1,1);
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
