%2.1
cell = readcell('Assignment2_materials.xlsx');    %通过阅读help文档发现xlsread并不被推荐使用，通过readcell直接读取元胞数组cell
%2.2
fields = readcell('Assignment2_materials.xlsx','Range','A1:E1');   %通过Range读取特定行列数据 使最终的struct符合要求
cell2 = readcell('Assignment2_materials.xlsx','Range','A2:E5');   
struct = cell2struct(cell2,fields,2);                       %元胞数组转结构体，使用cell to struct,了解用法之后补充参数fields和dim
%2.3
grade = xlsread('Assignment2_materials.xlsx','C2:E5');      %直接读取成绩相关数据
mean(grade)                                                 %计算三门课的平均成绩
sort(ans,'descend')                                         %题目要求降序，补充参数'descend'

