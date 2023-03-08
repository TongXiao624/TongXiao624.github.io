%[word,result]表示function的返回值，getword函数名称，d：参数值
function [word,result] = getword(img)
%参数初始化
word=[];flag=0;y1=8;y2=0.5;
    while flag == 0
        [m,n] = size(img);
        wide = 0;
        % ~=:关系运算符号：不等于；左右两边表达式不等时结果为1
        %找出本次要分隔符好的有右边界
        while sum(img(:,wide+1)) ~= 0 && wide <= n-2
            wide = wide+1;
        end
        temp = slicing(imcrop(img,[1 1 wide m]));
        [m_temp,n_temp] = size(temp);
        if wide < y1 && n_temp/m_temp > y2
            %消除本次分割的字符便于下一次字符分割
            img(:,1:wide) = 0;
            if sum(sum(img)) ~= 0 
                img = slicing(img);     %切割出最小区域
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
        
        