function wateringplot(field, pipe, HeadPos, S, E, NumMoves, k)

contourf(field.x,field.y,S);
hold on
for i = 1:length(pipe)
    x = pipe(i).pos(1) + cos(pipe(i).ang)*HeadPos;
    y = pipe(i).pos(2) + sin(pipe(i).ang)*HeadPos;
    h = plot(x,y,'-ko');
    set(h,'Color',[0,0,0],'LineWidth',2,'MarkerFaceColor',[0,0,0]);
end
set(gca,'DataAspectRatio',[1,1,1],'XTick',[0,80],'YTick',[0,30]);

xlabel(sprintf('Total Moves = %d,  CU = %.1f',NumMoves,E));
title(sprintf('%5d Iterations',k));
drawnow
hold off