%% 一维插值函数 例：机床加工
% 待加工零件的外形根据工艺要求由一组数据(x,y) 给出（在平面情况下），
% 用程控铣床加工时每一刀只能沿 x方向和 y 方向走非常小的一步，
% 这就需要从已知数据得到加工所要求的步长很小的坐标(x,y)。
% 
% 下表中给出的(x,y)数据位于机翼断面的下轮廓线上，假设需要得到 
% x坐标每改变 0.1 时的 y 坐标。试完成加工所需数据，画出曲线，
% 并求出 0 =x 处的曲线斜率和 13 ≤x≤ 15 范围内 y 的最小值。
% 
% 要求用分段线性和三次样条三种插值方法计算。
x0=[0 3 5 7 9 11 12 13 14 15];
y0=[0 1.2 1.7 2.0 2.1 2.0 1.8 1.2 1.0 1.6];
x=0:0.1:15;
 
y1=interp1(x0,y0,x);%默认的插值方法：线性插值
 
y2=interp1(x0,y0,x,'spline');%三次样条插值
 
pp1=csape(x0,y0);%三次样条插值，使用默认边界条件即Lagrange边界条件
y3=fnval(pp1,x);%求被插值点函数值
 
pp2=csape(x0,y0,'second');%三次样条插值，边界为二阶导数
y4=fnval(pp2,x);
 
%画图
subplot(1,4,1)
plot(x0,y0,'*',x,y1)
title('分段线性插值')
 
subplot(1,4,2)
plot(x0,y0,'*',x,y2)
title('三次样条插值')
 
subplot(1,4,3)
plot(x0,y0,'*',x,y3)
title('三次样条插值(Lagrange)')
 
subplot(1,4,4)
plot(x0,y0,'*',x,y4)
title('三次样条插值(Second)')
 
%因三次样条插值曲线光滑，故采用y3计算斜率
%近似计算每一点的斜率
dx=diff(x);
dy=diff(y3);
dy_dx=dy./dx;
%求x=0处斜率(即dy_dx计算的斜率中的第一个元素)
dy_dx0=dy_dx(1)
%求[13,15]范围内最小值
ytemp=y3(131:151);
ymin=min(ytemp);
index=find(y3==ymin);
xmin=x(index);
[xmin,ymin]

fprintf('可以看出，分段线性插值的光滑性较差。 \n')

%% 二维插值函数     
% z=interp2(x0,y0,z0,x,y,'method')
% 其中 x0,y0 分别为m 维和n维向量，表示节点，z0 为 m *n 维矩阵
%（按照表格原样输入就行），表示节点值，x，y 为一维数组，表示插值点。
% 注：
% ①x与y应是方向不同的向量，即一个是行向量，另一个是列向量
% ②z 为矩阵，它的行数为 y 的维数，列数为 x的维数，表示得到的插值
% ③'method' 的用法同上面的一维插值。

x0=100:100:500;
y0=100:100:400;
z0=[636 697 624 478 450;698 712 630 478 420;680 674 598 412 400;662 626 552 334 310];
x=100:1:500;
y=100:1:400;
 
%采用interp2函数进行二维插值时，插值点中x，y应是方向不同的向量，故转置
y=y';
z2=interp2(x0,y0,z0,x,y,'spline');
mesh(x,y,z2)
title('二维三次样条插值')
 
%求最高点地址
[i j]=find(z2==max(max(z2)));
%求最高点坐标
res_x=x(i)
res_y=y(j)
zmax=z2(i,j)


%% 插值节点为散点
% ZI = griddata(x,y,z,XI,YI)
% 其中 x、y、z均为 n 维向量。向量XI、 YI 是给定的网格点的横坐标和纵坐标，
% 返回值 ZI 为网格（XI，YI）处的函数值。XI 与 YI 应是方向不同的向量，
% 即一个是行向量，另一个是列向量.
% 例： 在某海域测得一些点（x,y）处的水深 z 由下表给出，在矩形区域内画出海底曲面的图形。 
x=[129 140 103.5 88 185.5 195  105 157.5  107.5 77 81 162 162 117.5];
y=[7.5 141.5 23 147 22.5 137.5 85.5 -6.5 -81 3 56.5 -66.5 84 -33.5];
z=[4 8 6 8 6 8 8 9 9 8 8 9 4 9];
%求x和y的最大值和最小值，便于定xi和yi的范围
xmm=minmax(x)
ymm=minmax(y)
xi=xmm(1):xmm(2);
yi=ymm(1):ymm(2);
 
zi1=griddata(x,y,z,xi,yi','cubic');%立方插值
zi2=griddata(x,y,z,xi,yi','nearest');%最近点插值
zi=zi1;
zi(isnan(zi1))=zi2(isnan(zi1));%将立方插值中的不确定值换成最近点插值的结果
%画图
mesh(xi,yi,zi)