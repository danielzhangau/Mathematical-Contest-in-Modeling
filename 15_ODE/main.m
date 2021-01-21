% ode45是解决数值解问题的首选方法，若长时间没结果，
% 应该就是刚性的，可换用ode15s试试。
% [T,Y] = ode45(‘odefun’,tspan,y0)
% [T,Y] = ode45(‘odefun’,tspan,y0,options)
% [T,Y,TE,YE,IE] = ode45(‘odefun’,tspan,y0,options)
% sol = ode45(‘odefun’,[t0 tf],y0...)
% 其中: odefun是函数句柄,可以是函数文件名,匿名函数句柄或内联函数名；
%           tspan 是求解区间 [t0 tf]，或者一系列散点[t0,t1,...,tf]；
%           y0 是初始值向量
%           T 返回列向量的时间点
%           Y 返回对应T的求解列向量
%           options 是求解参数设置,可以用odeset在计算前设定误差,输出参数,事件等
%            TE 事件发生时间
%            YE 事件发生时之答案
%             IE 事件函数消失时之指针i

% ode45求解
tspan=[3.9 4];        % 求解区间(可改)
y0=[8 2];             % 初值
[t,x]=ode45('odefun',tspan,y0);
% 画图
plot(t,x(:,1),'-o',t,x(:,2),'-*')
% plot(t,x(:,1))画出来的是x的第一列数据，即为y；
% plot(t,x(:,2))画出来的是x的第二列数据，即为y’；
legend('y','y''')
title('y'''' =-t*y+exp(t)*y''+3*sin(2*t)')
xlabel('t')
ylabel('y')