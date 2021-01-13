% a是邻接矩阵这里我就随便赋值啦
% 我们用 result3×n 的第一、二、三行分别表示生成树边的起点、终点、权集合。
%{
名称：prim算法（matlab）
用途：用于求最小生成树
输入：原图（用邻接矩阵的方式表示）,a是输入的矩阵
输出：最小生成树（使用弧表表示法），result是输出的矩阵
main idea:
(i) P={v1}, Q=theta;
(ii)while P ~= V
    找最小边pv, 其中p belong to P, v belong to V-P
    P = P + {v}
    Q = Q + {pv}
    end
%}
clc;clear;
a=zeros(7);
a(1,2)=50; a(1,3)=60;
a(2,4)=65; a(2,5)=40;
a(3,4)=52;a(3,7)=45;
a(4,5)=50; a(4,6)=30;a(4,7)=42;
a(5,6)=70;
a=a+a';
a(find(a==0))=inf; % 将为0的地方变为无穷
result=[];         % 用于存储最小生成树
p=1; % p中存储已处理的点
tb=2:length(a);
while length(result)~=length(a)-1 % 当边的个数=原图中顶的个数-1时，退出循环
    temp=a(p,tb);  % tb中存储着其他未处理的顶,temp存储着未处理的边的权重
    temp=temp(:);  % d存储找到的最小权
    d=min(temp);   % 有点类似于贪心
    [jb,kb]=find(a(p,tb)==d); % 找到最小权的横纵坐标
    j=p(jb(1));    % j存储找到的边的起始位置，可能有多最小权，但我们只取一个
    k=tb(kb(1));   % k存储找到的边的末位置，可能有多最小权，但我们只取一个z
    result=[result,[j;k;d]];  % 将该边的信息存储至result中
    p=[p,k];tb(find(tb==k))=[]; 
end
result