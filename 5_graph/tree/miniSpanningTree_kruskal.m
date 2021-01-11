%{
名称：Kruskal 算法（matlab）
用途：用于求最小生成树
输入：原图（用邻接矩阵的方式表示），但是计算时使用弧表表示法，a是输入矩阵
输出：最小生成树（使用弧表表示法），result是输出矩阵
注意：  
%}
clc;clear;
% 输入邻接矩阵
a(1,2)=50; a(1,3)=60; a(2,4)=65; a(2,5)=40;
a(3,4)=52;a(3,7)=45; a(4,5)=50; a(4,6)=30;
a(4,7)=42; a(5,6)=70;

[i,j,b]=find(a);
% 构建弧表表示矩阵data，及所有边的索引矩阵index
data=[i';j';b'];index=data(1:2,:);
loop=max(size(a))-1;
result=[];
while length(result)<loop
temp=min(data(3,:));
flag=find(data(3,:)==temp);
flag=flag(1);
v1=index(1,flag);v2=index(2,flag);
if v1~=v2
result=[result,data(:,flag)];
end
index(find(index==v2))=v1;
data(:,flag)=[];
index(:,flag)=[];
end
result