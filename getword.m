%[word,result]��ʾfunction�ķ���ֵ��getword�������ƣ�d������ֵ
function [word,result] = getword(img)
%������ʼ��
word=[];flag=0;y1=8;y2=0.5;
    while flag == 0
        [m,n] = size(img);
        wide = 0;
        % ~=:��ϵ������ţ������ڣ��������߱��ʽ����ʱ���Ϊ1
        %�ҳ�����Ҫ�ָ����õ����ұ߽�
        while sum(img(:,wide+1)) ~= 0 && wide <= n-2
            wide = wide+1;
        end
        temp = slicing(imcrop(img,[1 1 wide m]));
        [m_temp,n_temp] = size(temp);
        if wide < y1 && n_temp/m_temp > y2
            %�������ηָ���ַ�������һ���ַ��ָ�
            img(:,1:wide) = 0;
            if sum(sum(img)) ~= 0 
                img = slicing(img);     %�и����С����
            else
                word=[];
                flag = 1;
            end
        else
            word = slicing(imcrop(img,[1,1,wide,m]));
            img(:,1:wide) = 0;
            if sum(sum(img)) ~= 0
                img = slicing(img);
                flag = 1;
            else
                img = [];
            end
        end
    end
    result = img;
        
        