% 抛物插值

function y=sin_T(x0,y0,x1,y1,x2,y2,x)
% sin_T输出sin(x)使用抛物插值计算得到的函数值
% 例如: y=sin_T(0.32,0.314567,0.34,0.333487,0.36,0.352274,0.3367)
%       y = 
%           0.3304
%       R = 
%           2.0315e-07
 
% 以下为判断输入值是否合法的代码
if nargin~=7
    error('请输入线性插值的插值节点和插值点')
end
if ~( isnumeric(x0)&&isnumeric(y0)&&isnumeric(x1)&&isnumeric(y1)&&isnumeric(x2)&&isnumeric(y2)&&isnumeric(x) )
    error('输入参数必须是数')
end
 
% 核心计算的代码
y=y0*(x-x1)*(x-x2)/((x0-x1)*(x0-x2))+y1*(x-x0)*(x-x2)/((x1-x0)*(x1-x2))+y2*(x-x0)*(x-x1)/((x2-x0)*(x2-x1));
 
% 以下为求解截断误差的代码
y_0=cos(x0); % 因为sin(x)的三阶导数是cos(x),那么只要求出x0,x1,x2的cos值，然后去最大即可得到M3
y_1=cos(x1);
y_2=cos(x2);
syms M3;
if y_0>y_1
    M3=y_0;
else
    M3=y_1;
end
if y_2>M3
    M3=y_2;
end
R=M3*abs((x-x0)*(x-x1)*(x-x2))/6
end

%% How to call
% y=sin_T(0.32,0.314567,0.34,0.333487,0.36,0.352274,0.3367)