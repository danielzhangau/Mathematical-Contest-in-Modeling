% 打印输出上下界
function y = OutputLowerAndUpperBounds()

global lowerBound;
global upperBound;

disp("此时下界、上界分别为");
disp(lowerBound);
if isempty(upperBound)
    disp('  无上界')
else
    disp(upperBound);
end

end

