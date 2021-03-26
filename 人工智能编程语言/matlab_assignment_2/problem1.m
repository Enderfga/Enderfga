%1.1
fid = fopen('Companionship of Books.txt ', 'w');         %以'w'方式创建该txt文件
A = "A man may usually be known by the books he reads as well as by the company he keeps. for there is a companionship of books as well as of men. one should always live in the best company, whether it be of books or of men.";
fprintf(fid,'%s',A);                                     %以字符串的数据类型写入指定内容
fclose(fid);                                             %关闭txt文件，防止出错
%1.2
fid = fopen('Companionship of Books.txt ','r');          %以‘r’：只读方式打开文件（默认方式可省略不写）
B=fscanf(fid,'%c');k=0;                                  %将文本以字符的形式（包括空格）读入B中；为k赋初值
for n=1:length(B)                                        %通过for循环与多重if语句进行判断
    if B(n)=='b'
        if B(n+1)=='o'
            if B(n+2)=='o'
                if B(n+3)=='k'
                    if B(n+4)=='s'
                        k=k+1;
                    end
                end
            end
        end
    end
end                                                      %end不能漏，且注意缩进
fclose(fid);                                             %关闭txt文件，防止出错
disp('How many times did the word "books" appear')
disp(k);
%1.3
for n=1:length(B)                                        %依旧利用for循环遍历B，找到指定位置                
    if B(n)=='.'                                         %第二句话的首字母应该在'.'后第二位（后第一位是空格）
        if B(n+2) >= 'a'&&B(n+2) <= 'z'                  %检查目标大写与否
            B(n+2)=upper(B(n+2));break;                  %使用upper函数将字符串转换为大写;简化第一节课char(abs()-32)的做法
        end                                              %只检查第二句话首字母，故直接使用break跳出循环；若删去可以转换每一句话首字母，但要注意n+2>length
    end
end
disp(B)




            
           