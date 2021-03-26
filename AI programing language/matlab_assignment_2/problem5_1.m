%5.1
[x,y,z] = meshgrid( linspace( -10, 10, 100 ) );
a = randi([-10 10]);
b = randi([-10 10]);
c = randi([-10 10]);
d = randi([-10 10]);
f = x.^2/a^2 + y.^2/b^2 + z.^2/c^2 ;
isosurface(x, y, z, f, d);