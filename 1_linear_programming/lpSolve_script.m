clc
clear all
close all
 
syms x1 x2 x3 y1 y2 y3 y4 y5;
 
% 根据例题构造线性规划（LP）的标准方程
C = [0 0 -2 -3 -1];
A = [1 0 1/3 1/3 1/3;0 1 1/3 4/3 7/3];
b = [1 ;3];
X = [y1 y2 x1 x2 x3].';
 
resultTable = lpSolve(C,X,A,b);