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
