% main.m
% 分支定界法
% -----------------------------------------------
% 求解模型：
% min z = f * x
% A * x <= b
% x >= 0,且为整数
% ---------------------------------------------------
clear global;
clear;
clc;

global result; % 存储所有整数解
global lowerBound; % 下界
global upperBound; % 上界
global count; % 用以判断是否为第一次分支

count = 1;

f = [-40, -90];
A = [8, 7;
    7, 20;];
b = [56; 70];
Aeq = [];
beq = [];
lbnd = [0; 0];
ubnd = [inf; inf];

BinTree = createBinTreeNode({f, A, b, Aeq, beq, lbnd, ubnd});
if ~isempty(result)
    [fval,flag]=min(result(:,end)); % result中每一行对应一个整数解及对应的函数值
    Result=result(flag,:);
    disp('该整数规划问题的最优解为：');
    disp(Result(1,1:end-1));
    disp('该整数规划问题的最优值为：');
    disp(Result(1,end));
else
    disp('该整数规划问题无可行解');
end