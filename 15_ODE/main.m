%% ode45求解
tspan=[3.9 4];        % 求解区间
y0=[8 2];             % 初值
[t,x]=ode45('odefun',tspan,y0);
%% 画图
plot(t,x(:,1),'-o',t,x(:,2),'-*')
legend('y','y''')
title('y'''' =-t*y+exp(t)*y''+3*sin(2*t)')
xlabel('t')
ylabel('y')