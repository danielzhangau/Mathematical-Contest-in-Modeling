%
% MCM 2006 PROBLEM A: Positioning and Moving Sprinkler Systems for Irrigation
%
% Reference: Brian Camley, Bradley Klingenberg and Pascal Getreuer. 
%            Sprinkle, Sprinkle Little Yard. 
%            The UMAP Journal 27 (3) (2006) 295–314.
%
% zhou lvwen: zhou.lv.wen@gmail.com.   April 18, 2016
%%

function [E, NumMoves] = SAIrrigation(NumHeads, NumSteps)
% SAIRRIGATION  Main function of Simulated Annealing for Irrigation system

if nargin==0; 
    NumHeads = 2;            % Number of heads (spreaklers) at the pipe.
    NumSteps = 4;            % Number of steps (pipes)
end

FieldLen = 80;               % Length of the field.         [unit: m     ]
FieldWid = 30;               % Width of the field.          [unit: m     ]
PipeLen  = 20;               % Length of pipe

Tmax = 1e-1;                 % Initial temperature for Simulated Annealing
Tmin = 1e-5;                 % Final temperature for Simulated Annealing

kmax = 3000;                 % Number of simulated iterations 

% Initializa field
nx = FieldLen;                         % X Resolution
ny = FieldWid;                         % Y Resolution
field.size = [FieldLen, FieldWid];     % field size.        [unit: m x m ]
% grid(i,j)'s postion = (field.x(i,j), filed.y(i,j))
[field.x,field.y] = meshgrid(linspace(0,80,nx),linspace(0,30,ny));

% Initializa pipes' position and angle, and heads
for i = 1:NumSteps
   pipe(i).pos = PipeLen/2 + rand(1,2).*(field.size-PipeLen); 
   pipe(i).ang = rand*2*pi;
end
HeadPos = linspace(-PipeLen/2, PipeLen/2, NumHeads);

% Generate the inital watering and uniformity
[S, E] = watersum(field, NumHeads, pipe, HeadPos);
NumMoves = totalmoves(S, NumSteps);    % Total number of moves
% Plot the initial watering
wateringplot(field, pipe, HeadPos, S, E, NumMoves, 0);


for k = 1:kmax
    % Cooling the temperature
    T = Tmax + (Tmin - Tmax)*k/kmax;
    
    % Generate randomly a neighbouring solution
    [pipeNew] = perturb(pipe, HeadPos, T);
    % Compute watering uniformity (Enew) of the new solution
    [Snew, Enew] = watersum(field, NumHeads, pipeNew, HeadPos);
    
    % Metropolis Algorithm
    if Enew > E | rand < exp((Enew - E)/T)
        pipe = pipeNew;                % Accept new solution
        E = Enew; S = Snew;            % Update E and S

        NumMoves = totalmoves(S, NumSteps);  % Total number of moves
        
        % Plot the current watering
        wateringplot(field, pipe, HeadPos, S, E, NumMoves, k);
    end
end
