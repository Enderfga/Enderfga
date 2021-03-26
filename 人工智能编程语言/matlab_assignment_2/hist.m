A = randperm(98);B = A(1:10);
for n=1:19
    A = randperm(98);                                
    B = [B A(1:10)];
end
histogram(B,'BinWidth',1)
    