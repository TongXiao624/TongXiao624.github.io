I = imread('����1.jpg');
figure(1),imshow(I);    %figure()����������һ������
title('ԭͼ');


%%%%%%%%%%ͼ��ת��Ϊ�Ҷ�ͼ��
I_gray = rgb2gray(I);
figure(2),subplot(1,2,1),imshow(I_gray);
title('�Ҷ�ͼ');
figure(2),subplot(1,2,2),imhist(I_gray);
title('�Ҷ�ֱ��ͼ');


%%%%%%%%%%%����Prewitt���ӽ��б�Ե���;shreshold:������ֵ;both:��ʾ����
I_edge = edge(I_gray,'prewitt',0.15,'both');
figure(3),imshow(I_edge);
title('Prewitt���Ӽ���Ե');



%%%%%%%%%%%��ʴ
se = [1;1;1];     %se:�ṹԪ�أ����Խṹ���ݣ�
I_erode = imerode(I_edge,se);
figure(4),imshow(I_erode);
title('��ʴ��ͼ��');


%%%%%%%%%%%ƽ��ͼ��
se = strel('rectangle',[25,25]);
I_smooth = imclose(I_erode,se);
figure(5),imshow(I_smooth);
title('ƽ�����ͼ��');
I_remove = bwareaopen(I_smooth,3000);     %�Ƴ��������������С��2000�Ķ���
figure(6),imshow(I_remove);
title('ɾ��С�������Ӷ���');
[y,x,z] = size(I_remove);
I_double = double(I_remove);
tic    %tic�������浱ǰʱ�䣬����ʹ��toc����¼�������ʱ��

%%%%%%%%%%%���ص�ͳ��
CarNum_y = zeros(y,1);    %zeros���ܷ���y*1��double���;���
for i=1:y     %���ص�ͳ��
    for j=1:x
        if(I_double(i,j,1)==1)
            CarNum_y(i,1) = CarNum_y(i,1) + 1;
        end
    end
end


%%%%%%%%%%%Y����������ȷ��
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
title('Y����ͼ��Χ');


%%%%%%%%%%%X�����Ʒ�Χȷ��
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
t = toc;     %toc��¼�������ʱ�䣻tic��toc������¼�������ʱ��

%%%%%%%%%%%�ָ���ɺ��ԭͼ
CarX1 = CarX1-1;
CarX2 = CarX2+1;
%CAR1��Ӧͼ���˹�����
%I_division = I(CarY1+5:CarY2-8,CarX1:CarX2-8,:); 
%CAR2��Ӧͼ���˹�����
%I_division = I(CarY1:CarY2,CarX1+8:CarX2,:); %�Գ�����������˹�У��
%CAR3��Ӧͼ���˹�����
I_division = I(CarY1:CarY2,CarX1:CarX2,:);
figure(7),subplot(1,2,2),imshow(I_division);
title('���Ʋ�ɫͼ��');
imwrite(I_division,'���Ʒָ�ͼ��.jpg');
Img_division = imread('���Ʒָ�ͼ��.jpg');
Img_gray = rgb2gray(Img_division);
imwrite(Img_gray,'���ƻҶ�ͼ��.jpg');

%%%%%%%%%%%������бУ��
qingxiejiao = rando_get(Img_gray);
Img_gray = imrotate(Img_gray,qingxiejiao,'bilinear','crop');  
[m_rotate,n_rotate] = size(Img_gray);
%CAR1��Ӧͼ���˹�����
%Img_gray = Img_gray(12:m_rotate-5,8:n_rotate-9,:);     
Img_gray = slicing(Img_gray);
figure(8),subplot(3,2,1),imshow(Img_gray);
title('1.���ƻҶ�ͼ��');

%%%%%%%%%%%���������Ӧ��ֵ�ָ�ͼ��
I=im2double(Img_gray);
se=strel('disk',10);%se.Neighborhood:10*10Բ��
ft=imtophat(I,se);% ��ñ�任
gt=uint8(255*ft);
Th=graythresh(ft);                       
I_binary=imbinarize(ft,Th);%��ֵ�ָ�                       
%figure,imshow(G),title('�ֲ���ֵ');
figure(8),subplot(3,2,2),imshow(I_binary);
title('2.��������Ӧ��ֵ�ָ�ͼ��');

imwrite(I_binary,'��������Ӧ��ֵ�ָ�ͼ��.jpg');
%figure(8),subplot(3,2,2),imshow(I_binary);
%title('2.���ƶ�ֵ��ͼ��');
figure(8),subplot(3,2,3),imshow(I_binary);
title('3.���ƾ�ֵ�˲�ǰͼ��');

%%%%%%%%%%%��ͼ����о�ֵ�˲�����
h = fspecial('average',3);     %����Ԥ������˲�����;average��ʾ��ֵ�˲����ӣ�3*3����
I_binary = imbinarize(filter2(h,I_binary));     %imbibarize������������ֵ�任���ѻҶ�ͼ��ת��Ϊ��ֵͼ��
imwrite(I_binary,'���ƾ�ֵ�˲���ͼ��.jpg');
figure(8),subplot(3,2,4),imshow(I_binary);
title('4.���ƾ�ֵ�˲���ͼ��');

%%%%%%%%%%%�Գ��Ʋ��ֽ������͡���ʴ����
se = eye(2);     %eye()����������2*2�ĵ�λ����
[m,n] = size(I_binary);
%�����ֵͼ���ж�������������������ı��Ƿ����0.365
if bwarea(I_binary)/(m*n) >= 0.365     %bwarea()���ڼ����ֵͼ���ж��������
    d = imerode(I_binary,se);     %��ʴ����
elseif bwarea(I_binary)/(m*n) <= 0.235     %�����ֵͼ���ж�������������������ı�ֵ�Ƿ�С��0.235
    d = imdilate(I_binary,se);     %���ͺ���
end
imwrite(I_binary,'���ͻ�ʴ����ͼ��.jpg');
figure(8),subplot(3,2,5),imshow(I_binary);
title('5.���ͻ�ʴ����ͼ��');


%%%%%%%%%%%Ѱ�����������ֵĿ�
I_binary = slicing(I_binary);     %ɾ��û��ͼ��ĺ�ɫ����
[~,n] = size(I_binary);
k1 = 1;k2 = 1;s = sum(I_binary);j = 1;
while j~=n     %���������ַ�֮�����������
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
title('6.�ָ����ͼ��'); 

%%%%%%%%%%%�ָ��7���ַ�
y1 = 10;y2 = 0.25; flag = 0;word1 = [];

%%%%%%%%%%%�ָ����һ�����ƺ���,��һ����СΪ 40*20
while flag == 0
    [m_binary,~] = size(I_binary);
    left = 1;
    wide = 0;
    while sum(I_binary(:,wide+1)) ~=0
        wide = wide + 1;
    end
    if wide < y1     %�������Ϣ����δ����ɾ�
        I_binary(:,1:wide) = 0;
        I_binary = slicing(I_binary);
    else
        I_temp = slicing(imcrop(I_binary,[1,1,wide,m_binary]));
        [m_temp,~] = size(I_temp);
        all = sum(sum(I_temp));
        two_thirds = sum(sum(I_temp(round(m_temp/3):2*round(m_temp/3),:)));
        %�ָ����ͼ��1word1
        if two_thirds/all > y2
            flag = 1;
            word1 = I_temp;
        end
        I_binary(:,1:wide) = 0;
        %figure(9),imshow(I_binary);
        %title('�ָ���һ���ַ�����ͼ��'); 
        I_binary = slicing(I_binary);
    end
end
word1 = slicing(word1);
figure(9),subplot(2,7,1),imshow(word1);
title('1');

%%%%%%%%%%%�ָ����2���ַ�,��һ����СΪ 40*20
[word2,I_binary] = getword(I_binary);
word2 = slicing(word2);
subplot(2,7,2),imshow(word2);
title('2');

%%%%%%%%%%%�ָ����3���ַ�,��һ����СΪ 40*20
[word3,I_binary] = getword(I_binary);
word3 = slicing(word3);
subplot(2,7,3),imshow(word3);
title('3');

%%%%%%%%%%%�ָ����4���ַ�,��һ����СΪ 40*20
[word4,I_binary] = getword(I_binary); 
word4 = slicing(word4);
subplot(2,7,4),imshow(word4);
title('4');

%%%%%%%%%%%�ָ����5���ַ�,��һ����СΪ 40*20
[word5,I_binary] = getword(I_binary);  
word5 = slicing(word5);
subplot(2,7,5),imshow(word5);
title('5');

%%%%%%%%%%%�ָ����6���ַ�,��һ����СΪ 40*20
[word6,I_binary] = getword(I_binary);  
word6 = slicing(word6);
subplot(2,7,6),imshow(word6);
title('6');

%%%%%%%%%%%�ָ����7���ַ�,��һ����СΪ 40*20
[word7,I_binary] = getword(I_binary);  
word7 = slicing(word7);
subplot(2,7,7),imshow(word7);
title('7');

%%%%%%%%%%%ͼ���һ��
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

%%%%%%%%%%%�ַ�ʶ��
liccode = char(['0':'9' 'A':'Z' '�ն�����³��ԥ����']);
SubBw2=zeros(40,20);%����һ��40*20��С�������  
l=1;  
for I=1:7  
      ii=int2str(I);%��������ת�ַ�������  
      t=imread([ii,'.jpg']);  
      SegBw2=imresize(t,[40 20],'nearest');%���Ŵ���
      SegBw2=double(SegBw2)>20;
      if l==1                 %��һλ����ʶ��
          kmin=37;
          kmax=46;
      elseif l==2             %�ڶ�λ A~Z ��ĸʶ��  
            kmin=11;  
            kmax=36;
      else l>=3               %����λ�Ժ�����ĸ������ʶ��  
            kmin=1;  
            kmax=36;
      end
      
      for k2=kmin:kmax
          fname=strcat('�ַ�ģ��\',liccode(k2),'.jpg');  
          SamBw2 = imread(fname);  
          SamBw2=double(SamBw2)>1;
          for  i=1:40  
              for j=1:20  
                  SubBw2(i,j)=SegBw2(i,j)-SamBw2(i,j);  
              end
          end
          % �����൱������ͼ����õ�������ͼ
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
figure(10),imshow(Img_gray),title (['���ƺ���:', Code],'Color','b'); 
    
    