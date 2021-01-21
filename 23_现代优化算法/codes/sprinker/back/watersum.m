function [S, CU] = watersum(field, profile, NumHeads, pipe, HeadPos)
%WATERSUM Sum of all the water and return CU

S = zeros(size(field.x));
for i = 1:length(pipe)
    for j = 1:NumHeads
        x = pipe(i).pos(1) + cos(pipe(i).ang)*HeadPos(j);
        y = pipe(i).pos(2) + sin(pipe(i).ang)*HeadPos(j);
        r = sqrt( (field.x-x).^2 + (field.y-y).^2 );
        S = S + profile(r);
    end
end

CU = 100*( 1 -(std(S(:))/mean(S(:))) );