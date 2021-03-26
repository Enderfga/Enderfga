%3
fid = fopen('Lucky guys.txt ', 'a');   %创建txt文件，且必须以‘a’方式，确保追加数据到文件末尾
name = readcell('Assignment2_student_namelist.xlsx');    %读取名单到元胞数组中，共98位
A = randperm(98);                                 %生成1~98的无序数组
B=char(name(A(1:10)));                      %取前10位，并用char函数转换
fprintf(fid,'%s\r\n',B');                   %打印到txt文件中
