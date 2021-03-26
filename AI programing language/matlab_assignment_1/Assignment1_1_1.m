global g;
p = 1;
g = 2;
s = sparse(eye(5));
c = [4+5i 9-3i 7+6i];     %先给几种类型的变量赋值
who                       %分别使用，观察区别
whos