function qingxiejiao = rando_get(I)
I1 = wiener2(I,[5,5]);     %��άά���˲�����ȥ����ɢ������
I2 = edge(I1,'canny');
theta = 1:180;     %theta:ͶӰ����ĽǶ�
[R,xp] = radon(I2,theta);     %��ĳ������theta��radon�任�����������
[r,c] = find(R>=max(max(R)));  %��������R�����ֵ����λ�ã���ȡ���б� 
% max(R)�ҳ�ÿ���Ƕȶ�Ӧ�����ͶӰ�Ƕ� Ȼ�ڶ���ȡ���ֵ����Ϊ������б�Ǽ�90��
J=c;  %����R���б���Ƕ�Ӧ��ͶӰ�Ƕ�
qingxiejiao=90-c; %������б��
end