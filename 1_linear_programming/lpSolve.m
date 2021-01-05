function resultTable = lpSolve(C,X,A,b)
% 目标函数系数C，变量X，约束条件系数A，约束项右侧常数b,约束条件个数m
% 传入参数来自于标准形式的LP方程
%% 求解过程
% 将标准方程中的系数矩阵A分解成基B与非基N,将X分解为基变量XB与非基变量XN
m = size(A,1);
B = A(1:m,1:m);
N = A(1:m,m+1:end);
CB = C(1,1:m);
CN = C(1,m+1:end);
XB = X(1:m,:);
XN = X(m+1:end,:);
 
invB = pinv(B);
% XB = invB*b - invB*N*XN
 
% 令XN = zeros（3，1）.'构造方程的一个基本解Xbasic
% invBxb >= 0时候，称B是Lp的可行基，此时Xbasic是Lp的基本可行解
invBxb = invB*b;
Xbasic = [invBxb ; zeros(3,1)];
%{
% 验证C*X 是否等于 CB*invB*b + (CN - CB*invB*N)*XN
C*X
CB*invB*b + (CN - CB*invB*N)*XN
%}
% 验证基本可行解是否是LP的最优解,当creterion>=0时候，Xbasic是最优解，B是最优基
creterion = C - CB*invB*A;
% 将LP转写称为典式形式y00\Ym\invBxN\invBxb,Y0n是LP的检验数（相对成本系数）
% minS= y00 + y0n*XN
% s.t : XB = invBxb - invBxN*XN
% X>=0
y00 = CB*invB*b;
Y0n = CN - CB*invB*N;
invBxN = invB*N;
% 构造方程的单纯形表
disp('构造LP的单纯形表')
TableLP = [0 0 X.';0 -y00 zeros(1,m) Y0n;XB invBxb eye(m) invBxN];
disp(TableLP)
while(min(Y0n) < 0)
    % 对TableLP中第二行非基部分进行判断，如果有负数元素，则认为当前解不是最优解
    % 然后判断invBxN的元素与0的关系，全<=0时候没有最优解，当存在>0的元素时候，执行
    % 换基操作，循环迭代直至最优解（为更具普适性，可以改用bland规则进行判断换基）
    vectorBuffer = TableLP(2,2+1:end);
    goleSensTable2 = TableLP;
    for i = 1:m
        mNonBasic = find(goleSensTable2(1,:) == TableLP(i+2,1));
        vectorBuffer(mNonBasic - 2) = 0;
    end
    qPosition = find(vectorBuffer < 0,1);
    
    % 取q所在列为主列，判断主列元素全部<=0是否成立，若成立则方程没有最优解，计算结束
    if(max(TableLP(3:end,2 + qPosition)) < 0)
        disp('LP方程没有最优解');
        break;
    else
        % 若不成立继续换基操作
        yi0 = TableLP(3:end,2);
        yiq = TableLP(3:end,2+qPosition);
        theta = min(yi0(yiq>0)./yiq(yiq>0));
        Jp = find(yi0./yiq == theta,1);
        
        % 取Jp所在行为主行，并以ypq为主元继续进行换基操作,xq为进基，xp为出基
        ypq = TableLP(2+Jp,2+qPosition);
        TableLP(2 + Jp,1) = TableLP(1,2 + qPosition);
        TableLP(2+Jp,2:end) = TableLP(2+Jp,2:end)/ypq;
        for i = 1:m+1
            if(i ~= Jp + 1)
                TableLP(i + 1,2:end) = TableLP(i + 1,2:end) - TableLP(Jp + 2,2:end)*...
                    TableLP(i + 1,2 +qPosition);
            end
        end
    end
    disp('更新单纯形表')
    disp(TableLP)
    
    % 更新检验数Y0n
    goleSensTable1 = TableLP;
    for i = 1:m
    mNonBasic = find(goleSensTable1(1,:) == TableLP(i+2,1));
    goleSensTable1(:,mNonBasic) = [];
    end 
    Y0n = goleSensTable1(2,3:end);
end
 
%% 打印结果
fprintf('最优方案：\n');
for i = 1:numel(X)-m
    if(ismember(XN(i),TableLP(3:end,1)))
        Jp = find(TableLP(:,1) == XN(i));
        fprintf('%s = %f \n',XN(i),TableLP(Jp,2));
    else
        fprintf('%s = 0\n',XN(i));
    end
end
maxS = TableLP(2,2);
fprintf('最优目标函数值：%f\n\n',maxS);
 
 
%% 目标函数系数的灵敏度分析
% 分离非基系数矩阵
goleSensTable = TableLP;
for i = 1:m
    mNonBasic = find(goleSensTable(1,:) == TableLP(i+2,1));
    goleSensTable(:,mNonBasic) = [];
end
goleSensTable = goleSensTable(:,3:end);
% 判断基变量的灵敏度区间
for i = 1:numel(X)-m
    if(ismember(XN(i),TableLP(3:end,1)))
        fprintf('基变量 %s 的价格区间 \n',XN(i));
        Jp = find(TableLP(:,1) == XN(i));
        vector1 = goleSensTable(2,:);
        vector2 = goleSensTable(Jp,:);
        Dmax = vector1(vector2>0)./vector2(vector2>0)*-1;
        Dmin = vector1(vector2<0)./vector2(vector2<0)*-1;
        if(isempty(max(Dmax)))
            xMin = -Inf;
        else
            xMin = -C(X == XN(i)) + max(Dmax);
        end
        
        if(isempty(min(Dmin)))
            xMax = Inf;
        else
            xMax = -C(X == XN(i)) + min(Dmin);
        end
        fprintf('[%f,%f]\n',xMin,xMax);
    end
end
 
% 判断非基变量灵敏度区间
for i = 1:numel(X)-m
    if(~ismember(XN(i),TableLP(:,1)))
        fprintf('非基变量 %s 的价格不超过 \n',XN(i));
        xNonMax = -C(i + m) + TableLP(2,2+m+i);
        fprintf('%f\n',xNonMax);
    end
end
 
%% 返回结果
resultTable = TableLP;
end

