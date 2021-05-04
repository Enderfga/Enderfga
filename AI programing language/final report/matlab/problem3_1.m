image = imread('peppers.png');
[width,height,z]=size(image);
result1 = double(image)./255;
%k1、k2作为判断临界点
k=0.1;%SNR=0.9
%rand(m,n)是随机生成m行n列的矩阵，每个矩阵元素都在0-1之间
%这里k是0.1，所以小于k的元素在矩阵中为1，反之为0
a1=rand(width,height)<k;
a2=rand(width,height)<k;
%合成彩色图像
t1=result1(:,:,1);
t2=result1(:,:,2);
t3=result1(:,:,3);
%分成黑点 白点 随机
t1(a1&a2)=0;
t2(a1&a2)=0;
t3(a1&a2)=0;
t1(a1& ~a2)=255;
t2(a1& ~a2)=255;
t3(a1& ~a2)=255;
result1(:,:,1)=t1;
result1(:,:,2)=t2;
result1(:,:,3)=t3;
result1=uint8(result1);
imwrite(result1, 'peppers_sp.png');
%%%%%%%%%%%%%%%%%%%%分界线%%%%%%%%%%%%%%%%%%%%
av=0;
std=0.1;
u1=rand(width,height);
u2=rand(width,height);
x=std*sqrt(-2*log(u1)).*cos(2*pi*u2)+av;
result2=double(image)./255+x*255;
result2=uint8(result2);
imwrite(result2, 'peppers_Gaussion.png');
%%%%%%%%%%%%%%%%%%%%分界线%%%%%%%%%%%%%%%%%%%%
