% https://blog.csdn.net/weixin_44765473/article/details/107755895

clear,clc
a = [1 2 3 4 5;     % 第一行是金银类型，用来表示系统的状态
     2 2 6 5 4;     % 第二行是金银重量
     6 3 5 4 6];    % 第三行是金银价值

b = perms(a(1, :));
v = [];
for i = 1:size(a,2)-1
    c = b;
    id1 = find(c <= i);
    id2 = find(c >  i);
    c(id1) = 0;
    c(id2) = 1;
    c = unique(c,'rows');
    v = [v; c];    				% 用0、1变量表示第k状态的决策
end
v = [ones(1,5); v; zeros(1,5)]; % 所有阶段的所有状态都存放在v中
 
F = [];
for i = 1:size(v,1)
    if (a(2,:) * v(i,:)') <= 10 % 约束条件（背包的承重范围内）
        f = (a(3,:) * v(i,:)'); % 阶段指标
        F = [F, f];             % 指标函数
    end
end
best_value = max(F)             % 指标函数最优值