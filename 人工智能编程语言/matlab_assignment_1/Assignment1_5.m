A = cat(1,ones(10,40),repmat(2,10,40)) ;    %构造矩阵A
B = A;
for j=1:40
    B(11,j)=1/j;
end                                       %构造矩阵B
c = repmat(3,20,1);
C = [B c];                                  %构造矩阵C
D = C;i = 1;
while i<=10
    D(i,i) = i*C(i,i);
    i = i+1;
end                                       %构造矩阵D
