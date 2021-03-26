sum = 0;n = 0;                  %初始化总和sum的值并设置一个计数的变量n
Folder = 1;Fold = 1;            %给n=1和2的两种特殊情况赋值
for i = 3:10000                 %i的上限设置足够大，确保在这其中找出40项
    Fcurr = Folder+Fold;
    if mod(Fcurr,2)==0||mod(Fcurr,5)==0   %判断是否符合条件，将符合的项累加
        sum = sum+Fcurr
        n = n+1;          
    end
    if n==40                               %计数变量n达到40时跳出循环，输出总和
        break
    end
    Folder = Fold;
    Fold = Fcurr;
end
disp(['Sum=',num2str(sum)])    %输出总和的值