x=[0.5 1 1.5 2 2.5 3];
y=[1.75 2.45 3.81 4.8 8 8.6];
xi=0.5:0.1:3;
% interp1叫做分段线性插值，就是先插入一些点，再将这些点用直线连接起来。
y1=interp1(x,y,xi);
y2=spline(x,y,xi);
y3=Lagrange(x,y,xi);
subplot(3,1,1)
plot(x,y,'o',xi,y1)
title('分段线性插值')
subplot(3,1,2)
plot(x,y,'o',xi,y2)
title('三次样条插值')
subplot(3,1,3)
plot(x,y,'o',xi,y3)
title('拉格朗日插值')