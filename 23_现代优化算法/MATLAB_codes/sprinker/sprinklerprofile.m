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
        p = h*(1-r/R).*(r<R);        % Sprinkler profile. [unit: m/s   ]
    case 'exp'
        an = 4*J/(n*pi*R^2); % For volume conserve.         [unit: m/s   ]
        p = an * exp(-r./R);           % Sprinkler profile. [unit: m/s   ]
    case 'exp2'
        an = 4*J/(n*pi*R^2); % For volume conserve.         [unit: m/s   ]
        p = an * exp(-2*r.^2./R.^2);   % Sprinkler profile. [unit: m/s   ]
end

p = p * 100 * 3600;          % Application rate.            [unit: cm/hr ]
