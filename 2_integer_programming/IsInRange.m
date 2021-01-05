% IsInRange.m
% 判断分支问题的解是否在上下界的范围中，若不在，剪去
function y = IsInRange(fval)
    global lowerBound;
    global upperBound;

    if isempty(upperBound) & fval >= lowerBound
        y = 1;
    else if  (fval >= lowerBound & fval <= upperBound)
        y = 1;
    else
        y = 0;
    end
end