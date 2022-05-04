%Patient Model
p = 2;
ng=[ 1]; dg=[ 1 2*p p^2];
%PD Controller+pump model : Gc(s) Gp(s)
K1=2;K2=5 ; %PD gains
dc= [ 1 0 ];
nc1= [K2 K1 ] ;
%Closed-loop transfer functions
[ n1, d]=series (ng, dg , nc1 , dc) ;
[ num,den ]=cloop (n1,d) ;

%Responses to a step input
tf=20; %maximum time for settling from design spec DS1
t=[ 0: 0.1:tf ] ;
Ro=10;
y=step(Ro*num, den,t ) ;
%compute percent overshoot and settling times
[ ymax tp ] =max(y) ; overshoot = ( ( ymax-10) /10)*100
r=201 ; while(y (r) >9.8&y (r)<10.2),r=r-1 ; end;
ts = (r+1 ) *0.1
%Generate step response plots

plot(t,y, [ 0 tf],[11.5 11.5])
text (10,11.5,'15% overshoot ')
grid
ylabel ( 'Percent decrease in mean arterial pressure (%) ')
xlabel ( ' Time (min)')
title ( 'Mean arterial pressure (MAP) step input response with R(s)=10/s.' )
