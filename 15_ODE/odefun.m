function dx=odefun(t,x)
dx=zeros(2,1)      % 初始化dx 
dx(1)=x(2)
dx(2)=-t*x(1)+exp(t)*x(2)+3*sin(2*t)
end
