function y0=three_spline(x,y,x0)
    %%计算系数a
    a=y;
    n=length(y);
    %%计算插值h
    h=diff(x);
    %%计算二次微分值m
    %计算左边矩阵A
    A=cal_A(h,n)
    %计算右边矩阵B
    B=cal_B(y,h,n)
    m=linsolve(A,B);
    %计算系数b，d
    [b,d]=cal_bd(h,m,y);
    %计算系数c
    c=m/2;
    %计算y0值
    for i=1:length(x0)
        t=sort(x);
        t(end+1)=x0(i);
        t=sort(t);
        aaa=find(t==x0(i));  
        if length(aaa)>1         
            index=aaa(1);
        else
            index=aaa-1;
        end
        y0(i)=a(index)+b(index)*(x0(i)-x(index))+c(index)*power((x0(i)-x(index)),2)+d(index)*power((x0(i)-x(index)),3);
    end
end