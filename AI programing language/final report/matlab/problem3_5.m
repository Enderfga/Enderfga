%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%主函数%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 读取
f = imread('original_face.jpeg');
 
% 设置参数
r = 15;% 滤波半径
a = 9;% 全局方差
b = 0.3;% 局部方差
 
% 判断二维图还是三维图
if ismatrix(f)
    g = bfilt_gray(f,r,a,b);
else
    g = bfilt_rgb(f,r,a,b);
end
 
% 显示
subplot(121)
imshow(f)
subplot(122)
imshow(g)
 
 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%灰度图双边滤波%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function g = bfilt_gray(f,r,a,b)
% f灰度图；r滤波半径；a全局方差；b局部方差
[x,y] = meshgrid(-r:r);
w1 = exp(-(x.^2+y.^2)/(2*a^2));
f = tofloat(f);%f = im2double(f);
 
h = waitbar(0,'Applying bilateral filter...');
set(h,'Name','Bilateral Filter Progress');
 
[m,n] = size(f);
f_temp = padarray(f,[r r],'symmetric');
g = zeros(m,n);
for i = r+1:m+r
    for j = r+1:n+r
        temp = f_temp(i-r:i+r,j-r:j+r);
        w2 = exp(-(temp-f(i-r,j-r)).^2/(2*b^2));
        w = w1.*w2;
        s = temp.*w;
        g(i-r,j-r) = sum(s(:))/sum(w(:));
    end
    waitbar((i-r)/m);
end
% g = revertclass(g);
 
end
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%彩色图双边滤波%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function g = bfilt_rgb(f,r,a,b)
% f灰度图；r滤波半径；a全局方差；b局部方差
[x,y] = meshgrid(-r:r);
w1 = exp(-(x.^2+y.^2)/(2*a^2));
f = tofloat(f);%f = im2double(f);
 
h = waitbar(0,'Applying bilateral filter...');
set(h,'Name','Bilateral Filter Progress');
 
fr = f(:,:,1);
fg = f(:,:,2);
fb = f(:,:,3);
[m,n] = size(fr);
fr_temp = padarray(fr,[r r],'symmetric');
fg_temp = padarray(fg,[r r],'symmetric');
fb_temp = padarray(fb,[r r],'symmetric');
[gr,gg,gb] = deal(zeros(size(fr)));
 
 
for i = r+1:m+r
    for j = r+1:n+r
        temp1 = fr_temp(i-r:i+r,j-r:j+r);
        temp2 = fg_temp(i-r:i+r,j-r:j+r);
        temp3 = fb_temp(i-r:i+r,j-r:j+r);
        dr = temp1 - fr_temp(i,j);
        dg = temp2 - fg_temp(i,j);
        db = temp3 - fb_temp(i,j);
        w2 = exp(-(dr.^2+dg.^2+db.^2)/(2*b^2));
        w = w1.*w2;
        gr(i-r,j-r) = sum(sum(temp1.*w))/sum(w(:));
        gg(i-r,j-r) = sum(sum(temp2.*w))/sum(w(:));
        gb(i-r,j-r) = sum(sum(temp3.*w))/sum(w(:));
    end
    waitbar((i-r)/n);
end
g = cat(3,gr,gg,gb);
% g = revertclass(g);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%可以用到的函数%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [out,revertclass]=tofloat(in)
identity=@(x) x;
tosingle=@im2single;
 
table={'uint8',tosingle,@im2uint8
'uint16',tosingle,@im2uint16
'int16',tosingle,@im2int16
'logical',tosingle,@logical
'double',identity,identity
'single',identity,identity};
 
classIndex=find(strcmp(class(in),table(:,1)));
 
if isempty(classIndex)
    error('unsupported input immage class.');
end
 
out=table{classIndex,2}(in);
revertclass=table{classIndex,3}; 
end