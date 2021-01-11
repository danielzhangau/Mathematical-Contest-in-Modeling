function [cost,CMatrix]=Assignment(C,ismin) 
% Assignment problem solved by hungarian method. 
% 
% input: 
% C         - 系数矩阵，可以适应workers和tasks数目不同的情形 
% ismin     - 1表示最小化问题，0表示最大化问题 
% ouput: 
% cost      - 最终花费代价 
% CMatrix   - 对应的匹配矩阵，元素1所在位置c_{ij}表示j task分配给 i worker。 
% 
  
[m,n]=size(C); 
if ismin==0 
    C=max(C(:))-C; 
end 
 
%workes 和tasks数目不相同 
if m<n 
    C=[C;zeros(n-m,n)]; 
elseif m>n 
    C=[C zeros(m,m-n)]; 
end 
copyC=C; 
d=max(m,n);% 最终系数矩阵的维度 
C=C-repmat(min(C,[],2),1,d); 
C=C-repmat(min(C,[],1),d,1); 
 
%% 方法一 
while 1 
    A=int8((C==0)); 
    nIZeros=0;  % 独立0元素的个数 
    while 1 
        r=sum(A==1,2); % 每一行0元素的个数 
        [~,idr]=find(r'==1);%找到只有一个0元素的行 
        if ~isempty(idr) % 如果找到这样的行 
            tr=A(idr(1),:); 
            [~,idc]=find(tr==1);%找到0元素所在列 
            A(idr(1),idc)=2;%标注独立元素 
            tc=A(:,idc); 
            tc(idr(1))=2; 
            [~,idr]=find(tc'==1);%找到独立0元素所在列的其他0元素 
            A(idr,idc)=-2;%划掉独立0元素所在列的其余0元素 
            nIZeros=nIZeros+1; 
        else 
            c=sum(A==1,1); % 每一列0元素的个数 
            [~,idc]=find(c==1);%找到只含有一个0元素的列 
            if ~isempty(idc)% 找到这样的列 
                tc=A(:,idc(1)); 
                [~,idr]=find(tc'==1);%0元素所在的行 
                A(idr,idc(1))=2;%标注独立0元素 
                tr=A(idr,:); 
                tr(idc(1))=2; 
                [~,idc]=find(tr==1);%独立0元素所在行的其他0元素 
                A(idr,idc)=-2;%划掉独立0元素所在行的其余0元素 
                nIZeros=nIZeros+1; 
            else 
                break; 
            end 
        end 
    end 
 
    if nIZeros==d 
        %计算最优解 
        CMatrix=(A==2); 
         
        if ismin==1 
            cost=sum(copyC(:).*CMatrix(:)); 
        else 
            cost = sum((max(copyC(:))-copyC(:)).*CMatrix(:)); 
        end 
        CMatrix=CMatrix(1:m,1:n); 
        break;%找到d个独立0元素，则跳出循环 
    else% 独立0元素个数不足，就要找盖0线了 
        r=sum(A==2,2); 
        [~,idr]=find(r'==0);%不含有独立0元素的行 
        idrr=idr; 
        idcc=[]; 
        while 1 
            tr=A(idrr,:); 
            [~,idc]=find(tr==-2);%不含独立0元素的行中划掉的0元素所在列 
            if isempty(idc),break;end 
            tc=A(:,unique(idc)); 
            [idrr,~]=find(tc==2);%这些列中标注的0元素所在行 
            idr=[idr,idrr']; 
            idcc=[idcc,idc]; 
        end 
        idry=1:d; 
        idry(idr)=[];%盖0线所在的行索引 
        TempC=C;%存储非覆盖元素 
        TempC(idry,:)=[]; 
        TempC(:,idcc)=[]; 
        minUnOverlap=min(TempC(:)); 
        %更新系数矩阵 
        C=C-minUnOverlap; 
        C(idry,:)=C(idry,:)+minUnOverlap; 
        C(:,idcc)=C(:,idcc)+minUnOverlap; 
    end 
end 
%% 方法二 
% while 1 
%     CMatrix=zeros(d); 
%     nLines=0; 
%     A=(C==0); 
%     idx=[]; 
%     idy=[]; 
%     sr=[]; 
%     sc=[]; 
%     while 1 
%         r=sum(A,2); 
%         c=sum(A,1); 
%         r(sr)=0; 
%         c(sc)=0; 
%         trc=[r(:);c(:)]; 
%         [trc,idtrc]=sort(trc,1,'ascend'); 
%         [~,idn0]=find(trc'>0); 
%         if ~isempty(idn0) 
%             id=idtrc(idn0(1)); 
%             if id>d 
%                 tc=A(:,id-d); 
%                 [~,idr]=find(tc'==1); 
%                 A(idr(1),:)=0;  
%                 nLines=nLines+1; 
%                 idy=[idy,idr(1)]; 
%                 CMatrix(idr(1),id-d)=1; 
%                 sc=[sc,id-d]; 
%             else 
%                 tr=A(id,:); 
%                 [~,idc]=find(tr==1); 
%                 A(:,idc(1))=0; 
%                 nLines=nLines+1; 
%                 idx=[idx,idc(1)]; 
%                 CMatrix(id,idc(1))=1; 
%                 sr=[sr,id]; 
%             end  
%         else 
%             break; 
%         end 
%     end 
%     if nLines==d 
%         if ismin 
%             cost=sum(copyC(:).*CMatrix(:)); 
%         else 
%             cost=sum((max(copyC(:))-copyC(:)).*CMatrix(:)); 
%         end 
%         CMatrix=CMatrix(1:m,1:n); 
%         break; 
%     else 
%         tempC=C; 
%         tempC(idy,:)=[]; 
%         tempC(:,idx)=[]; 
%         minUnOverlap=min(tempC(:)); 
%         C=C-minUnOverlap; 
%         C(idy,:)=C(idy,:)+minUnOverlap; 
%         C(:,idx)=C(:,idx)+minUnOverlap; 
%     end 
% end 
 
end 

%% how to call
% C = [10 5 9 19 11; 13 19 6 12 14; 3 2 4 4 5; 18 9 12 17 15; 11 6 14 19 10];
% [cost, CMatrix] = Assignment(C, 1)