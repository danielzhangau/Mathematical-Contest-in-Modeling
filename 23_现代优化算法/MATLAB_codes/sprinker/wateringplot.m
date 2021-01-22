function wateringplot(field, pipe, HeadPos, S, E, NumMoves, k)
% WATERINGPLOT  Plot the watering of the field and pipes' location
%

contourf(field.x,field.y,S); % Plot the watering
hold on

% Draw pipes and heads
for i = 1:length(pipe)
    x = pipe(i).pos(1) + cos(pipe(i).ang)*HeadPos;
    y = pipe(i).pos(2) + sin(pipe(i).ang)*HeadPos;
    plot(x,y,'-k.', 'LineWidth',2, 'MarkerSize', 25);
end
set(gca,'DataAspectRatio',[1,1,1],'XTick',[0,80],'YTick',[0,30]);

% Print number of total moves required and Uniformity
xlabel(sprintf('Total Moves = %d,  CU = %.1f',NumMoves, E));
% Print current Iteration
title(sprintf('%5d Iterations',k));
drawnow
hold off
