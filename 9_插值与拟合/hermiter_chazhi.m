function y=hermiter_chazhi(X,Y,x1,x)
%求差分表
m=length(X);
YY=zeros(m);
YY(:,1)=Y;
for i=2:m
    for j=i:m
        YY(j,i)=(YY(j,i-1)-YY(j-1,i-1))/(X(j)-X(j-i+1));
    end
end
%求A
A=x1-YY(2,2)-(X(2)-X(1))*YY(3,3);

%求插值
y=Y(1)+YY(2,2).*(x-X(1))+YY(3,3).*(x-X(1)).*(x-X(2))+A.*(x-X(1)).*(x-X(2)).*(x-X(3));
end
