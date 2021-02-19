clc;
clear all；
x=-4:0.1:4;
y1=normpdf(x,0,1);

n=norminv(1-0.01,0,1);
n=1.5;
x2 = -4:0.1:1.5;

y2 = normpdf(x2,0,1);

figure;
plot(x,y1);
xline(n,'--r');

grid;

hold on;
area(x2,y2,'LineStyle','--', 'FaceColor', '#0072BD');

xlabel('Z')
ylabel('L')
legend({'regular normal distribution', 'distribution line', 'Selected Area'});