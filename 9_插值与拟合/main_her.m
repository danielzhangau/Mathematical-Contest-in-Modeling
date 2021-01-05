function y=main_her()
x=[1/4:0.01:9/4];
f=x.^(3/2);
X=[1/4,1,9/4];
Y=[1/8,1,27/8];
x1=3/2;
y=hermiter_chazhi(X,Y,x1,x);

plot(x,y,"r")
grid on
hold on 
plot(x,f,"b")
scatter(X,Y)
legend("插值曲线","实际曲线")
end