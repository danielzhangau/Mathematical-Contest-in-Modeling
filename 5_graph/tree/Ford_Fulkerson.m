clc,clear
u(1,2)=1;u(1,3)=1;u(1,4)=2;u(2,3)=1;u(2,5)=2;
u(3,5)=1;u(4,3)=3;u(4,5)=3;
f(1,2)=1;f(1,3)=0;f(1,4)=1;f(2,3)=0;f(2,5)=1;
f(3,5)=1;f(4,3)=1;f(4,5)=0;
n=length(u);list=[];maxf(n)=1;
while maxf(n)>0
    maxf=zeros(1,n);pred=zeros(1,n);
    list=1;record=list;maxf(1)=inf;
    %list是未检查邻接点的标号点，record是已标号点
    while (~isempty(list))&(maxf(n)==0)
        flag=list(1);list(1)=[];
        label1= find(u(flag,:)-f(flag,:));
        label1=setdiff(label1,record);
        list=union(list,label1);
        pred(label1)=flag;
        maxf(label1)=min(maxf(flag),u(flag,label1)...
        -f(flag,label1));
        record=union(record,label1);
        label2=find(f(:,flag));
        label2=label2';
        label2=setdiff(label2,record);
        list=union(list,label2);
        pred(label2)=-flag;
        maxf(label2)=min(maxf(flag),f(label2,flag));
        record=union(record,label2);
    end
        if maxf(n)>0
            v2=n; v1=pred(v2);
            while v2~=1
                if v1>0
                    f(v1,v2)=f(v1,v2)+maxf(n);
                else
                    v1=abs(v1);
                    f(v2,v1)=f(v2,v1)-maxf(n);
                end
                v2=v1; v1=pred(v2);
            end
        end
end