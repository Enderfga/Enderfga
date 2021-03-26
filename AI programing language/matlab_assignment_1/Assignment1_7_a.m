Folder = 1;Fold = 1;            %给n=1和2的两种特殊情况赋值
for i = 3:15
    Fcurr = Folder+Fold;
    Folder = Fold;
    Fold = Fcurr;                %循环计算出最新的项，并不断替换掉旧的两项
end
disp(['F15 = ',num2str(Fcurr)])    %输出第15项的值