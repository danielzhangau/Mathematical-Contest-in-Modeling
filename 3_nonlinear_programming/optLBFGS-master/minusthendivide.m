x = [10,4,5,6,7,8,3,5,6,3];
y = [4,5,6,7,3,6,2,4,2,10];
size(x);
size(y);
sol=zeros(length(x)-1,1);
for iteration = 1:9
   sol(iteration)=(y(iteration+1)-y(iteration))/(x(iteration+1)-x(iteration));
end