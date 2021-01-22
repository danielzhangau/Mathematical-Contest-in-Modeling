% 
% MCM 2006 PROBLEM A: Positioning and Moving Sprinkler Systems for Irrigation
%
% Reference: Brian Camley, Bradley Klingenberg and Pascal Getreuer. 
%            Sprinkle, Sprinkle Little Yard. 
%            The UMAP Journal 27 (3) (2006) 295–314.
%
% zhou lvwen: zhou.lv.wen@gmail.com.   April 18, 2016
%%


NumHeads = 2;
NumSteps = 4;
PipeLength = 20;
Tmax = 1e-1;
Tmin = 1e-5;
kmax = 3000;
nx = 80;              % X Resolution
ny = ceil(nx*3/8);    % Y Resolution

field.size = [80, 30];

HeadPos = linspace(-PipeLength/2, PipeLength/2, NumHeads);
profile = @(r)SprinklerProfile(NumHeads, r);

%%% Perturbation initial and final magnitudes %%%
[field.x,field.y] = meshgrid(linspace(0,80,nx),linspace(0,30,ny));

for i = 1:NumSteps
   pipe(i).pos = PipeLength/2 + rand(1,2).*(field.size-PipeLength); 
   pipe(i).ang = rand*2*pi;
end

[S, E] = watersum(field, profile, NumHeads, pipe, HeadPos);

NumMoves = totalMoves(S, NumSteps);
wateringplot(field, pipe, HeadPos, S, E, NumMoves, 0);

for k = 1:kmax
    T = Tmax + (Tmin - Tmax)*k/kmax;
    [pipeNew] = perturb(pipe, HeadPos, T);
    [Snew, Enew] = watersum(field, profile, NumHeads, pipeNew, HeadPos);
    
    if Enew > E | rand < exp((Enew - E)/T)
        pipe = pipeNew;
        E = Enew; S = Snew;

        NumMoves = totalMoves(S, NumSteps);
        wateringplot(field, pipe,HeadPos, S, E, NumMoves, k);
    end
end