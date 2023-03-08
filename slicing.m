function e = slicing(img)
%显示图片d的大小
[m,n] = size(img);
%均为整数,参数初始化
top = 1;bottom = m;left = 1;right= n;
while sum(img(top,:)) == 0 && top <= m
    top = top+1;
end
while sum(img(bottom,:)) == 0 && bottom >= 1
    bottom = bottom-1;
end
while sum(img(:,left)) == 0 && left <= n
    left = left+1;
end
while sum(img(:,right)) == 0 && right >= 1
    right = right-1;
end
dd = right - left;
hh = bottom - top;
%返回图像的切割范围
e = imcrop(img,[left top dd hh]);%该函数用于返回图像的一个裁剪区域  

