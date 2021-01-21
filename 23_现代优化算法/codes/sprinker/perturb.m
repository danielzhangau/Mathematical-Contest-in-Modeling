function pipeNew = perturb(pipe, HeadPos, T)
% PERTURB  Pertube postion and angle of pipe to randomly generate a 
%          neighbouring solution
%
% New Position = Old Postion + scale * (0.5 -rand)
% New Angle    = Old Angle   + scale * (0.5 -rand)
%

scalePos = 60*T;             % Scale for disruption of position
scaleAng = pi*T;             % Scale for disruption of angle
pipeNew = pipe;

for i = 1:length(pipe)
    pipeNew(i).pos = pipe(i).pos + scalePos * [0.5-rand(1,2)];
    pipeNew(i).ang = pipe(i).ang + scaleAng * [0.5-rand(1,1)];

    x = pipeNew(i).pos(1) + cos(pipeNew(i).ang) * HeadPos;
    y = pipeNew(i).pos(2) + sin(pipeNew(i).ang) * HeadPos;
    % Check if any heads is outside the field and 
    if any(x<0|x>80) | any(y<0|y>30)
        pipeNew(i) = pipe(i);% if so return back to the original location
    end
end
