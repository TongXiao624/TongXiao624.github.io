I = imread('测试1.jpg');
figure(1),imshow(I);    %figure()函数：创建一个窗口
title('原图');


%%%%%%%%%%图像转换为灰度图像
I_gray = rgb2gray(I);
figure(2),subplot(1,2,1),imshow(I_gray);
title('灰度图');
figure(2),subplot(1,2,2),imhist(I_gray);
title('灰度直方图');


%%%%%%%%%%%采用Prewitt算子进行边缘检测;shreshold:设置阈值;both:表示方向
I_edge = edge(I_gray,'prewitt',0.15,'both');
figure(3),imshow(I_edge);
title('Prewitt算子检测边缘');



%%%%%%%%%%%腐蚀
se = [1;1;1];     %se:结构元素（线性结构数据）
I_erode = imerode(I_edge,se);
figure(4),imshow(I_erode);
title('腐蚀后图像');


%%%%%%%%%%%平滑图像
se = strel('rectangle',[25,25]);
I_smooth = imclose(I_erode,se);
figure(5),imshow(I_smooth);
title('平滑后的图像');
I_remove = bwareaopen(I_smooth,3000);     %移除连接区域中面积小于2000的对象
figure(6),imshow(I_remove);
title('删除小区域连接对象');
[y,x,z] = size(I_remove);
I_double = double(I_remove);
tic    %tic用来保存当前时间，而后使用toc来记录程序完成时间

%%%%%%%%%%%像素点统计
CarNum_y = zeros(y,1);    %zeros功能返回y*1的double零型矩阵
for i=1:y     %像素点统计
    for j=1:x
        if(I_double(i,j,1)==1)
            CarNum_y(i,1) = CarNum_y(i,1) + 1;
        end
    end
end


%%%%%%%%%%%Y方向车牌区域确定
[temp , MaxY] = max(CarNum_y); 
CarY1 = MaxY;
while ((CarNum_y(CarY1,1) >= 5) && (CarY1 > 1))
    CarY1 = CarY1 - 1;
end
CarY2 = MaxY;
while ((CarNum_y(CarY2,1) >=5 ) && (CarY2 < y))
    CarY2 = CarY2 +1;
end
ImgY = I(CarY1:CarY2,:,:);
figure(7),subplot(1,2,1),imshow(ImgY);
title('Y方向图像范围');


%%%%%%%%%%%X方向车牌范围确定
CarNum_x = zeros(1,x);
for j = 1:x
    for i = CarY1:CarY2
        if(I_double(i,j,1) == 1)
            CarNum_x(1,j) = CarNum_x(1,j) + 1;
        end
    end
end
CarX1 = 1;
while ((CarNum_x(1,CarX1) < 3) && (CarX1 < x))
    CarX1 = CarX1 + 1;
end
CarX2 = x;
while ((CarNum_x(1,CarX2) < 3) && (CarX2 > CarX1))
    CarX2 = CarX2 -1;
end
t = toc;     %toc记录程序完成时间；tic和toc用来记录程序完成时间

%%%%%%%%%%%分割完成后的原图
CarX1 = CarX1-1;
CarX2 = CarX2+1;
%CAR1对应图像人工处理
%I_division = I(CarY1+5:CarY2-8,CarX1:CarX2-8,:); 
%CAR2对应图像人工处理
%I_division = I(CarY1:CarY2,CarX1+8:CarX2,:); %对车牌区域进行人工校正
%CAR3对应图像人工处理
I_division = I(CarY1:CarY2,CarX1:CarX2,:);
figure(7),subplot(1,2,2),imshow(I_division);
title('车牌彩色图像');
imwrite(I_division,'车牌分割图像.jpg');
Img_division = imread('车牌分割图像.jpg');
Img_gray = rgb2gray(Img_division);
imwrite(Img_gray,'车牌灰度图像.jpg');

%%%%%%%%%%%车牌倾斜校正
qingxiejiao = rando_get(Img_gray);
Img_gray = imrotate(Img_gray,qingxiejiao,'bilinear','crop');  
[m_rotate,n_rotate] = size(Img_gray);
%CAR1相应图像人工处理
%Img_gray = Img_gray(12:m_rotate-5,8:n_rotate-9,:);     
Img_gray = slicing(Img_gray);
figure(8),subplot(3,2,1),imshow(Img_gray);
title('1.车牌灰度图像');

%%%%%%%%%%%计算出自适应阈值分割图像
I=im2double(Img_gray);
se=strel('disk',10);%se.Neighborhood:10*10圆盘
ft=imtophat(I,se);% 高帽变换
gt=uint8(255*ft);
Th=graythresh(ft);                       
I_binary=imbinarize(ft,Th);%阈值分割                       
%figure,imshow(G),title('局部阈值');
figure(8),subplot(3,2,2),imshow(I_binary);
title('2.车牌自适应阈值分割图像');

imwrite(I_binary,'车牌自适应阈值分割图像.jpg');
%figure(8),subplot(3,2,2),imshow(I_binary);
%title('2.车牌二值化图像');
figure(8),subplot(3,2,3),imshow(I_binary);
title('3.车牌均值滤波前图像');

%%%%%%%%%%%对图象进行均值滤波处理
h = fspecial('average',3);     %创建预定义的滤波算子;average表示均值滤波算子，3*3矩阵
I_binary = imbinarize(filter2(h,I_binary));     %imbibarize函数：采用阈值变换法把灰度图像转换为二值图像
imwrite(I_binary,'车牌均值滤波后图像.jpg');
figure(8),subplot(3,2,4),imshow(I_binary);
title('4.车牌均值滤波后图像');

%%%%%%%%%%%对车牌部分进行膨胀、腐蚀处理
se = eye(2);     %eye()函数：创建2*2的单位矩阵
[m,n] = size(I_binary);
%计算二值图像中对象的总面积与整个面积的比是否大于0.365
if bwarea(I_binary)/(m*n) >= 0.365     %bwarea()用于计算二值图像中对象总面积
    d = imerode(I_binary,se);     %腐蚀函数
elseif bwarea(I_binary)/(m*n) <= 0.235     %计算二值图像中对象的总面积与整个面积的比值是否小于0.235
    d = imdilate(I_binary,se);     %膨胀函数
end
imwrite(I_binary,'膨胀或腐蚀后车牌图像.jpg');
figure(8),subplot(3,2,5),imshow(I_binary);
title('5.膨胀或腐蚀后车牌图像');


%%%%%%%%%%%寻找连续有文字的块
I_binary = slicing(I_binary);     %删除没有图像的黑色部分
[~,n] = size(I_binary);
k1 = 1;k2 = 1;s = sum(I_binary);j = 1;
while j~=n     %计算两个字符之间空余区域宽度
    while s(j) == 0
        j = j+1;
    end
    k1 = j;
    while s(j)~=0 && j < n
        j = j+1;
    end
    k2 = j-1;
    if k2 - k1 >= round(n/6.5)
        [val,num] = min(sum(I_binary(:,k1:k2)));
        I_binary(:,k1+num) = 0;
    end
end
I_binary = slicing(I_binary);
figure(8),subplot(3,2,6),imshow(I_binary);
title('6.分割后车牌图像'); 

%%%%%%%%%%%分割出7个字符
y1 = 10;y2 = 0.25; flag = 0;word1 = [];

%%%%%%%%%%%分割出第一个车牌汉字,归一化大小为 40*20
while flag == 0
    [m_binary,~] = size(I_binary);
    left = 1;
    wide = 0;
    while sum(I_binary(:,wide+1)) ~=0
        wide = wide + 1;
    end
    if wide < y1     %左侧无信息部分未处理干净
        I_binary(:,1:wide) = 0;
        I_binary = slicing(I_binary);
    else
        I_temp = slicing(imcrop(I_binary,[1,1,wide,m_binary]));
        [m_temp,~] = size(I_temp);
        all = sum(sum(I_temp));
        two_thirds = sum(sum(I_temp(round(m_temp/3):2*round(m_temp/3),:)));
        %分割出的图像1word1
        if two_thirds/all > y2
            flag = 1;
            word1 = I_temp;
        end
        I_binary(:,1:wide) = 0;
        %figure(9),imshow(I_binary);
        %title('分割了一个字符后车牌图像'); 
        I_binary = slicing(I_binary);
    end
end
word1 = slicing(word1);
figure(9),subplot(2,7,1),imshow(word1);
title('1');

%%%%%%%%%%%分割出第2个字符,归一化大小为 40*20
[word2,I_binary] = getword(I_binary);
word2 = slicing(word2);
subplot(2,7,2),imshow(word2);
title('2');

%%%%%%%%%%%分割出第3个字符,归一化大小为 40*20
[word3,I_binary] = getword(I_binary);
word3 = slicing(word3);
subplot(2,7,3),imshow(word3);
title('3');

%%%%%%%%%%%分割出第4个字符,归一化大小为 40*20
[word4,I_binary] = getword(I_binary); 
word4 = slicing(word4);
subplot(2,7,4),imshow(word4);
title('4');

%%%%%%%%%%%分割出第5个字符,归一化大小为 40*20
[word5,I_binary] = getword(I_binary);  
word5 = slicing(word5);
subplot(2,7,5),imshow(word5);
title('5');

%%%%%%%%%%%分割出第6个字符,归一化大小为 40*20
[word6,I_binary] = getword(I_binary);  
word6 = slicing(word6);
subplot(2,7,6),imshow(word6);
title('6');

%%%%%%%%%%%分割出第7个字符,归一化大小为 40*20
[word7,I_binary] = getword(I_binary);  
word7 = slicing(word7);
subplot(2,7,7),imshow(word7);
title('7');

%%%%%%%%%%%图像归一化
word1 = imresize(word1,[40,20]);
word2 = imresize(word2,[40,20]);
word3 = imresize(word3,[40,20]);
word4 = imresize(word4,[40,20]); 
word5 = imresize(word5,[40,20]);
word6 = imresize(word6,[40,20]);   
word7 = imresize(word7,[40,20]);   
subplot(2,7,8),imshow(word1);
title('1');
subplot(2,7,9),imshow(word2);
title('2');
subplot(2,7,10),imshow(word3);
title('3');
subplot(2,7,11),imshow(word4);
title('4');
subplot(2,7,12),imshow(word5);
title('5');
subplot(2,7,13),imshow(word6);
title('6');
subplot(2,7,14),imshow(word7);
title('7');
imwrite(word1,'1.jpg');
imwrite(word2,'2.jpg');
imwrite(word3,'3.jpg');
imwrite(word4,'4.jpg');
imwrite(word5,'5.jpg');
imwrite(word6,'6.jpg');
imwrite(word7,'7.jpg');

%%%%%%%%%%%字符识别
liccode = char(['0':'9' 'A':'Z' '苏鄂津京辽鲁陕豫粤浙']);
SubBw2=zeros(40,20);%生成一个40*20大小的零矩阵  
l=1;  
for I=1:7  
      ii=int2str(I);%整形数据转字符串类型  
      t=imread([ii,'.jpg']);  
      SegBw2=imresize(t,[40 20],'nearest');%缩放处理
      SegBw2=double(SegBw2)>20;
      if l==1                 %第一位汉字识别
          kmin=37;
          kmax=46;
      elseif l==2             %第二位 A~Z 字母识别  
            kmin=11;  
            kmax=36;
      else l>=3               %第三位以后是字母或数字识别  
            kmin=1;  
            kmax=36;
      end
      
      for k2=kmin:kmax
          fname=strcat('字符模板\',liccode(k2),'.jpg');  
          SamBw2 = imread(fname);  
          SamBw2=double(SamBw2)>1;
          for  i=1:40  
              for j=1:20  
                  SubBw2(i,j)=SegBw2(i,j)-SamBw2(i,j);  
              end
          end
          % 以上相当于两幅图相减得到第三幅图
          Dmax=0;  
          for k1=1:40  
              for l1=1:20  
                  if  ( SubBw2(k1,l1) > 0 || SubBw2(k1,l1) <0 )  
                      Dmax=Dmax+1;  
                  end
              end
          end
          Error(k2)=Dmax;
      end
      Error1=Error(kmin:kmax);
      MinError=min(Error1);  
      findc=find(Error1==MinError);  
      Code(l*2-1)=liccode(findc(1)+kmin-1);  
      Code(l*2)=' ';  
      l=l+1;  
end  
figure(10),imshow(Img_gray),title (['车牌号码:', Code],'Color','b'); 
    
    