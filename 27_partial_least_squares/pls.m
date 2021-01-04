%% 使用偏最小二乘回归分析数据
clc, clear

load data.txt     % 注意此处对数据的要求：前三列 为自变量，后三列为因变量 每一列为一个指标，每一行为一个样本
mu = mean(data);  % 均值
sig = std(data);  % 标准差

%第一步将样本数据标准化, 并求出相关系数矩阵
rr = corrcoef(data);       % 求解相关系数矩阵
std_data = zscore(data);   % 数据标准化
n = 3; m = 3;              % n为自变量的个数，m为因变量的个数
x0 = data(:,1:n);          % 原始的自变量和因变量数据
y0 = data(:,n+1:end);      % 定义自变量为前n列，因变量为n+1到m列
e0 = std_data(:,1:n);      % 标准化后的自变量和因变量数据
f0 = std_data(:,n+1:end);  % e0为自变量归一化值，f0为因变量归一化值
num = size(e0,1);          % 样本点的个数(也就是说测量的样本多少)(size(A,n)如果在size函数的输入参数中再添加一项n，并用1或2为n赋值，则 size将返回矩阵的行数或列数。其中r=size(A,1)该语句返回的是矩阵A的行数， c=size(A,2) 该语句返回的是矩阵A的列数

chg = eye(n);              % w到w*变换矩阵的初始化(eye(n)生成nxn的单位阵)

%第二步根据标准化后原始数据矩阵e0和f0计算e0'f0f0'e0的最大特征矩阵所对应的特征向量并计算主元成分ti
for i = 1:n                
    % 计算w，w*和t的得分向量
    matrix = e0'*f0*f0'*e0;
    [vec,val] = eig(matrix);        % 求特征值和特征向量
    val = diag(val);                % 提出对角线元素，即提出特征值
    [val,ind] = sort(val,'descend');% 降序排列，ind为排序后原下标序号
    w(:,i) = vec(:,ind(1));         % 提出最大特征值对应的特征向量
    w_star(:,i) = chg*w(:,i);       % 计算w*的取值 (w*是最大特征值对应的特征向量w*)
    t(:,i) = e0*w(:,i);             % 计算成分ti的得分
    
    % 第三步建立回归模型, 并估计主成分系数alpha
    alpha = e0'*t(:,i)/(t(:,i)'*t(:,i));    % 计算第i个主成分系数向量
    chg = chg*(eye(n)-w(:,i)*alpha');       % 计算w 到w*的变换矩阵
    e = e0-t(:,i)*alpha';                   % 计算残差矩阵
    e0 = e;           % 将残差矩阵付给e0,再依次计算下一个主成分(循环计算出所有主成分)

    % 第四步pls确定主元r个数采用交叉检验法确认, 一般r<m
    % 计算ss(i)的值, 即残差的平方和(全部的样本)
    beta = [t(:,1:i),ones(num,1)]\f0;   % 回归方程的系数bi(因变量与主成分之间的系数)
    beta(end,:) = [];                   % 删除系数的常数项
    residual = f0-t(:,1:i)*beta;        % 求残差矩阵
    ss(i) = sum(sum(residual.^2));      % 求误差平方和

    % 计算press(i)的值
    for j = 1:num
        t1 = t(:,1:i); f1 = f0;
        discard_t = t1(j,:); discard_f = f1(j,:);   % 保存舍去的第j个样本点
        t1(j,:) = []; f1(j,:) = [];                 % 删除第j个观测值
        beta1 = [t1, ones(num-1,1)]\f1;             % 求回归分析的系数
        beta1(end,:) = [];                          % 删除回归系数的常数项
        residual = discard_f-discard_t*beta1;       % 求残差向量
        press_i(j) = sum(residual.^2);
    end

    press(i) = sum(press_i);
    if i > 1
        Q_h2(i) = 1-press(i)/ss(i-1);
    else
        Q_h2(1) = 1;
    end

    if Q_h2(i) < 0.0975
        fprintf('主成分个数r=%d', i);
        fprintf('   ');
        fprintf('交叉的有效性=%f', Q_h2(i));
        r = i;
        break;
    end
end

% 计算回归系数bi(求Y*关于自变量主元t的回归系数)
beta_z = [t(:,1:r),ones(num,1)]\f0;          % 求y关于t的回归系数
beta_z(end,:) = [];                          % 删除常数项
% 第五步根据所求相关回归系数求出的自变量y和x的回归系数, 并求出原始回归方程的常数项最后建立回归方程
coeff = w_star(:,1:r)*beta_z;                % 求y关于x的回归系数(是对标准化后的数据而言的)，每一列为一个回归方程

mu_x = mu(1:n);  mu_y = mu(n+1:end);         % 提出自变量和因变量的均值
sig_x = sig(1:n);  sig_y = sig(n+1:end);     % 提出自变量和因变量的标准差

for i = 1:m
    ch0(i) = mu_y(i)-mu_x./sig_x*sig_y(i)*coeff(:,i); % 计算原始数据的回归方程系数的常数项
end

for i = 1:m
    coeff_origin(:,i) = coeff(:,i)./sig_x'*sig_y(i);  % 计算原始数据的回归方程系数，每一列为一个回归方程
end

% 显示回归方程的系数，每一列是一个方程，每一列的第一个数是常数项,每一列为一个因变量与自变量们的回归方程
sol = [ch0;coeff_origin];      % 回归方程系数

%% 更直观的解释各个自变量的作用
figure
bar(coeff')%分别画出三个自变量对三个因变量标准化后回归方程的系数的的长度图
axis tight
hold on
annotation('textbox',[0.26 0.14 0.086 0.07],'String',{'单杠'},'FitBoxToText','off');
annotation('textbox',[0.56 0.14 0.086 0.07],'String',{'弯曲'},'FitBoxToText','off');
annotation('textbox',[0.76 0.14 0.086 0.07],'String',{'跳高'},'FitBoxToText','off');%在指定位置加注释
%% 拟合效果的确定
%所有点都在对角线附近均匀分布，则效果较好
ch0 = repmat(ch0, num, 1);     % repmat起复制矩阵组合为新矩阵的作用
y_hat = ch0 + x0*coeff_origin; % 计算Y 的预测值
y1_max = max(y_hat);           % 求预测值的最大值
y2_max = max(y0);              % 求观测值的最大值
y_max = max([y1_max;y2_max]);  % 求预测值和观测值的最大值
residual = y_hat - y0;         % 计算残差

% 画直线y=x,并画预测图
figure
subplot(2, 2, 1);
plot(0:y_max(1), 0:y_max(1), y_hat(:,1), y0(:,1), '*');
title('单杠成绩预测')

subplot(2, 2, 2);
plot(0:y_max(2), 0:y_max(2), y_hat(:,2), y0(:,2), 'O');
title('弯曲成绩预测')

subplot(2, 2, 3);
plot(0:y_max(3), 0:y_max(3), y_hat(:,3), y0(:,3), 'H');
title('跳高成绩预测')