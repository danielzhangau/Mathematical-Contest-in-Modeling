% 由于输油管道的长短不一或地质等原因，使每条管道上运输费用也不相同，
% 因此，除考虑输油管道的最大流外，还需要考虑输油管道输送最大流的最小费用。
% 图8 所示是带有运费的网络，其中第1 个数字是网络的容量，
% 第2 个数字是网络的单位运费。
function mainexample19
clear;clc;
global M num
c=zeros(6);u=zeros(6);
c(1,2)=2;c(1,4)=8;c(2,3)=2;c(2,4)=5;
c(3,4)=1;c(3,6)=6;c(4,5)=3;c(5,3)=4;c(5,6)=7;
u(1,2)=8;u(1,4)=7;u(2,3)=9;u(2,4)=5;
u(3,4)=2;u(3,6)=5;u(4,5)=9;u(5,3)=6;u(5,6)=10;
num=size(u,1);M=sum(sum(u))*num^2;
[f,val]=mincostmaxflow(u,c)

%求最短路径函数
function path=floydpath(w);
global M num
w=w+((w==0)-eye(num))*M;
p=zeros(num);
for k=1:num
    for i=1:num
        for j=1:num
            if w(i,j)>w(i,k)+w(k,j)
                w(i,j)=w(i,k)+w(k,j);
                p(i,j)=k;
            end
        end
    end
end
if w(1,num) ==M
    path=[];
else
    path=zeros(num);
    s=1;t=num;m=p(s,t);
    while ~isempty(m)
        if m(1)
            s=[s,m(1)];t=[t,t(1)];t(1)=m(1);
            m(1)=[];m=[p(s(1),t(1)),m,p(s(end),t(end))];
        else
            path(s(1),t(1))=1;s(1)=[];m(1)=[];t(1)=[];
        end
    end
end

%最小费用最大流函数
function [flow,val]=mincostmaxflow(rongliang,cost,flowvalue);
%第一个参数：容量矩阵；第二个参数：费用矩阵；
%前两个参数必须在不通路处置零
%第三个参数：指定容量值（可以不写，表示求最小费用最大流）
%返回值flow 为可行流矩阵,val 为最小费用值
global M
flow=zeros(size(rongliang));allflow=sum(flow(1,:));
if nargin<3
    flowvalue=M;
end
while allflow<flowvalue
    w=(flow<rongliang).*cost-((flow>0).*cost)';
    path=floydpath(w);%调用floydpath 函数
    if isempty(path)
        val=sum(sum(flow.*cost));
        return;
    end
    theta=min(min(path.*(rongliang-flow)+(path.*(rongliang-flow)==0).*M));
    theta=min([min(path'.*flow+(path'.*flow==0).*M),theta]);
    flow=flow+(rongliang>0).*(path-path').*theta;
    allflow=sum(flow(1,:));
end
val=sum(sum(flow.*cost));