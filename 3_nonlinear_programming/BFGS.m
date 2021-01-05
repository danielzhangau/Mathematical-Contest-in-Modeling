%***********************************************************************%
% Broyden, Fletcher, Goldfarb and Shanno (BFGS) formula
%***********************************************************************%
function  B  = BFGS(fun,GradOfU,Grad_Next,Xi_next,Xi,Bi)

 % Calculate Si term
  si               =  Xi_next   - Xi;
  
 % Calculate Yi term
  yi               =  Grad_Next - GradOfU;
 %
 % BFGS formula (Broyden, Fletcher, Goldfarb and Shanno)
 %
  B   =  Bi - ((Bi*si'*si*Bi)/(si*Bi*si')) + ((yi*yi')/(yi'*si'));

end