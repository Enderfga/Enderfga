Folder = 1;Fold = 1;            %给n=1和2的两种特殊情况赋值
j=0;array=zeros;                   %设置计数变量j和空数组array，便于给array(j)赋值;预分配内存加快计算速率
while 1i < 10000                 %i的上限设置足够大，确保在这其中符合条件的N
    Fcurr = Folder+Fold;
     if Fold<1000&&Fcurr>=1000   %判定是否到达N，若是则跳出循环
         S=[' N=' , num2str(j+2)];  %输出得到的N，且必须补上前2项
         disp(S) ;
         break
     end
    Folder = Fold;
    Fold = Fcurr;             %循环计算出最新的项，并不断替换掉旧的两项
    j = j+1;
    array(j)=Fcurr;           %将前N项放入数组array中
end
Fib=[1, 1, array];   %将前N项全部存入Fib中，便于输出
disp (Fib)      %打印出单索引数组
