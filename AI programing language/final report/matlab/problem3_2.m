[filename, pathname] = uigetfile({'*.png'; '*.jpeg'}, '选择图片');

%没有图像
if filename == 0
    return;
end

Image = imread([pathname, filename]);
[m, n, z] = size(Image);

%转换为灰度图
if z>1
    Image = rgb2gray(Image);
end
imwrite(Image, 'gray.png');
med3 = median_filter(Image, 3);
imwrite(med3, 'med3.png');
med5 = median_filter(Image, 5);
imwrite(med5, 'med5.png');
med7 = median_filter(Image, 7);
imwrite(med7, 'med7.png');

mea3 = avg_filter(Image, 3);
imwrite(mea3, 'mea3.png');
mea5 = avg_filter(Image, 5);
imwrite(mea5, 'mea5.png');
mea7 = avg_filter(Image, 7);
imwrite(mea7, 'mea7.png');