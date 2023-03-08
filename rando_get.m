function qingxiejiao = rando_get(I)
I1 = wiener2(I,[5,5]);     %二维维纳滤波函数去除离散噪声点
I2 = edge(I1,'canny');
theta = 1:180;     %theta:投影方向的角度
[R,xp] = radon(I2,theta);     %沿某个方向theta做radon变换，结果是向量
[r,c] = find(R>=max(max(R)));  %检索矩阵R中最大值所在位置，提取行列标 
% max(R)找出每个角度对应的最大投影角度 然在对其取最大值，即为最大的倾斜角即90度
J=c;  %由于R的列标就是对应的投影角度
qingxiejiao=90-c; %计算倾斜角
end