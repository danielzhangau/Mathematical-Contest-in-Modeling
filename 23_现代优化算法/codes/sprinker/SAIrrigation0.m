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
profile = @(r)sprinklerprofile(NumHeads, r); % Spreakler profile

% Generate the inital watering and uniformity
[S, E] = watersum(field, profile, NumHeads, pipe, HeadPos);
NumMoves = totalmoves(S, NumSteps);    % Total number of moves
% Plot the initial watering
wateringplot(field, pipe, HeadPos, S, E, NumMoves, 0);


for k = 1:kmax
    % Cooling the temperature
    T = Tmax + (Tmin - Tmax)*k/kmax;
    
    % Generate randomly a neighbouring solution
    [pipeNew] = perturb(pipe, HeadPos, T);
    % Compute watering uniformity (Enew) of the new solution
    [Snew, Enew] = watersum(field, profile, NumHeads, pipeNew, HeadPos);
    
    % Metropolis Algorithm
    if Enew > E | rand < exp((Enew - E)/T)
        pipe = pipeNew;                % Accept new solution
        E = Enew; S = Snew;            % Update E and S

        NumMoves = totalmoves(S, NumSteps);  % Total number of moves
        
        % Plot the current watering
        wateringplot(field, pipe, HeadPos, S, E, NumMoves, k);
    end
end


% -------------------------------------------------------------------------

function p = sprinklerprofile(n, r, method)
% SPRINKLERPROFILE  The sprinkler applies water as a function of distance
%
% Sprinkler Profile:
%      Linear :   p = Constant * (1 - r/R)
%      Exp    :   p = Constant * exp(-r/R)
%      Exp2   :   p = Constant * exp(-r^2/R^2)
%

if nargin == 2; method = 'linear'; end

g = 9.8;                     % Acceleration of gravity.     [unit: m/s^2 ]
J = 150e-3/60;               % Flux of water source.        [unit: m^3/s ]
d = 0.6e-2;                  % Inner diameter of nozzles.   [unit: m     ]
A = pi * (d/2)^2;            % cross-sectional pipe area.   [unit: m^2   ]
Pw = 420e3;                  % Water pressure               [unit: Pa    ]
Pa = 101e3;                  % Atmospheric pressure.        [unit: Pa    ]
rho = 10^3;                  % Density of water.            [unit: kg/m^2]
k = 0.2;                     % Drag coefficient             [unit: m^-1  ]
theta = pi/4;

v = sqrt((J/(A*n))^2 + 2*(Pw-Pa)/rho); % Output velocity.   [unit: m/s   ]
t = 2 * v*sin(theta) / g;    % Time of flight.              [unit: s     ]
R = (1/k)*log((k*t*v*cos(theta))+1);   % Sprinkler range.   [unit: m     ]

switch method
    case 'linear'
        h = 3*J/(pi*n*R^2);  % Y-intercept for the profile. [unit: m/s   ]
        p = (R-r).*(r<R)*(h/R);        % Sprinkler profile. [unit: m/s   ]
    case 'exp'
        an = 4*J/(n*pi*R^2); % For volume conserve.         [unit: m/s   ]
        p = an * exp(-r./R);           % Sprinkler profile. [unit: m/s   ]
    case 'exp2'
        an = 4*J/(n*pi*R^2); % For volume conserve.         [unit: m/s   ]
        p = an * exp(-2*r.^2./R.^2);   % Sprinkler profile. [unit: m/s   ]
end

p = p * 100 * 3600;          % Application rate.            [unit: cm/hr ]

% -------------------------------------------------------------------------

function [S, CU] = watersum(field, profile, NumHeads, pipe, HeadPos)
%WATERSUM  Sum of all the water and return uniformity (CU)
% 
% Coefficient of Uniformity: 
%                  CU = 100 * (1 - Standard deviation/ Mean)
%

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

% -------------------------------------------------------------------------

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

% -------------------------------------------------------------------------

function n = totalmoves(S, NumSteps)
% TOTALMOVES   
%
% Each part should receive at least  2 cm/4ds: Smin*t*NumPasses = 2 cm
% No part should receive more than 0.75 cm/hr: Smax*t = 0.75 cm
%
%                       2 Smax
%       NumPasses = -----------
%                    0.75 Smin
%

Smin = min(S(:)); 
Smax = max(S(:));
NumPasses = 2*Smax/(Smin*0.75);
n= ceil(NumPasses)*NumSteps;

% -------------------------------------------------------------------------

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