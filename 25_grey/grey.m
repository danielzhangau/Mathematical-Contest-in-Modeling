clc,clear
x0=[71.1 72.4 72.4 72.1 71.4 72.0 71.6]';%注意这里为列向量
n=length(x0);
lamda=x0(1:n-1)./x0(2:n) %计算级比
range=minmax(lamda') %计算级比的范围
x1=cumsum(x0); %累加运算
B=[-0.5*(x1(1:n-1)+x1(2:n)),ones(n-1,1)];
Y=x0(2:n);
u=B\Y
x=dsolve('Dx+a*x=b','x(0)=x0');
x=subs(x,{'a','b','x0'},{u(1),u(2),x1(1)});
yuce1=subs(x,'t',[0:n-1]);
%为提高预测精度，先计算预测值，再显示微分方程的解
y=vpa(x,6) %其中的6 表示显示6 位数字
yuce=[x0(2),diff(yuce1)] %差分运算，还原数据
epsilon=x0-yuce %计算残差
delta_ori=abs(epsilon./x0); %计算相对误差
delta=vpa(delta_ori,6)
rho=1-(1-0.5*u(1))/(1+0.5*u(1))*lamda' %计算级比偏差值