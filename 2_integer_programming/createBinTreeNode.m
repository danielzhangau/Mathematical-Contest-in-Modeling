% createBinTreeNode.m
% 构建二叉树，每一结点对应一解
function BinTree = createBinTreeNode(binTreeNode)

global result;
global lowerBound;
global upperBound;
global count;

if isempty(binTreeNode)
    return;
else
    BinTree{1} = binTreeNode;
    BinTree{2} = [];
    BinTree{3} = [];
    
    [x, fval, exitflag] = linprog(binTreeNode{1}, binTreeNode{2}, binTreeNode{3}, ...
        binTreeNode{4}, binTreeNode{5}, binTreeNode{6}, binTreeNode{7});
    if count == 1
%         upperBound = 0; % 初始下界为空
        lowerBound = fval;
        count = 2;
    end
    
    if ~IsInRange(fval)
        return;
    end

    if exitflag == 1
        flag = [];
        % 寻找非整数解分量
        for i = 1 : length(x)
            if round(x(i)) ~= x(i)
                flag = i;
                break;
            end
        end
        % 分支
        if ~isempty(flag)
            lowerBound = max([lowerBound; fval]);
            OutputLowerAndUpperBounds();
            lbnd = binTreeNode{6};
            ubnd = binTreeNode{7};
            lbnd(flag, 1) = ceil(x(flag, 1)); % 朝正无穷四舍五入
            ubnd(flag, 1) = floor(x(flag, 1));
            
            % 进行比较，优先选择目标函数较大的进行分支
            [~, fval1] = linprog(binTreeNode{1}, binTreeNode{2}, binTreeNode{3}, ...
        binTreeNode{4}, binTreeNode{5}, binTreeNode{6}, ubnd);
            [~, fval2] = linprog(binTreeNode{1}, binTreeNode{2}, binTreeNode{3}, ...
        binTreeNode{4}, binTreeNode{5}, lbnd, binTreeNode{7});
            if fval1 < fval2                
                % 创建左子树          
                BinTree{2} = createBinTreeNode({binTreeNode{1}, binTreeNode{2}, binTreeNode{3}, ...
            binTreeNode{4}, binTreeNode{5}, binTreeNode{6}, ubnd});

                % 创建右子树
                BinTree{3} = createBinTreeNode({binTreeNode{1}, binTreeNode{2}, binTreeNode{3}, ...
            binTreeNode{4}, binTreeNode{5}, lbnd, binTreeNode{7}});
            else
                % 创建右子树
                BinTree{3} = createBinTreeNode({binTreeNode{1}, binTreeNode{2}, binTreeNode{3}, ...
            binTreeNode{4}, binTreeNode{5}, lbnd, binTreeNode{7}});
                % 创建左子树          
                BinTree{2} = createBinTreeNode({binTreeNode{1}, binTreeNode{2}, binTreeNode{3}, ...
            binTreeNode{4}, binTreeNode{5}, binTreeNode{6}, ubnd});
            end
        else
            upperBound = min([upperBound; fval]);
            OutputLowerAndUpperBounds();
            result = [result; [x', fval]];
            return;
        end
    else
        % 剪枝
        return;
    end  
end