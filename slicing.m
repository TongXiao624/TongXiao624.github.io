function e = slicing(img)
%��ʾͼƬd�Ĵ�С
[m,n] = size(img);
%��Ϊ����,������ʼ��
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
%����ͼ����иΧ
e = imcrop(img,[left top dd hh]);%�ú������ڷ���ͼ���һ���ü�����  

