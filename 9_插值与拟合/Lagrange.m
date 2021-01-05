function y=Lagrange(x0,y0,x)
%输入：x0:节点变量数据
%      y0:节点函数值
%      x:插值数据
%输出：y:插值函数值
    n=length(x0);m=length(x);
    for i=1:m
        z=x(i);
        s=0.0;
        for k=1:n
            p=1.0;
            for j=1:n
                if j~=k
                    p=p*(z-x0(j))/(x0(k)-x0(j));
                end
            end
            s=p*y0(k)+s;
        end
        y(i)=s;
    end
end

% x0=[0.4,0.5,0.7,0.8]
% y0=[-0.916291,-0.693147,-0.356675,-0.223144]
% x=0.6
% y=Lagrange(x0,y0,x)