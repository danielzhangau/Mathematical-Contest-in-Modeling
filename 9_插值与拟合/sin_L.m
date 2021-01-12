% 已给sin0.32=0.314567,sin0.34=0.333487,sin0.36=0.352274,
% 用线性插值及抛物插值计算sin0.3367的值并估计截断误差。

% 线性插值
function y=sin_L(x0,y0,x1,y1,x)
% sin_L输出sin(x)使用线性插值计算得到的函数值
% 例如: y=sin_L(0.32,0.314567,0.34,0.333487,0.3367)
%       y = 
%           0.3304
%       R = 
%           9.1892e-06
 
% 以下为判断输入值是否合法的代码
if nargin~=5
    error('请输入线性插值的插值节点和插值点')
end
if ~( isnumeric(x0)&&isnumeric(y0)&&isnumeric(x1)&&isnumeric(y1)&&isnumeric(x) )
    error('输入参数必须是数')
end
 
% 核心计算的代码
y=y0+(y1-y0)*(x-x0)/(x1-x0);
 
% 以下为求解截断误差的代码
syms M2; % 因为sin(x)的二阶导数是本身，所以只需要挑出最大的y值，即可的到M2
if y0>y1
    M2=y0; 
else
    M2=y1;
end
R=M2*abs((x-x0)*(x-x1))/2
end

%% How to call
% y=sin_L(0.32,0.314567,0.34,0.333487,0.3367)