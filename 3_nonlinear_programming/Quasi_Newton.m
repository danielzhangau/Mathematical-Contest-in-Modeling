%***********************************************************************%
% Usage: [x,Iter,FunEval,EF] = Quasi_Newton (fun,x0,MaxIter,epsg,epsx)
%         fun: name of the multidimensional scalar objective function
%              (string). This function takes a vector argument of length
%              n and returns a scalar.
%          x0: starting point (row vector of length n).
%     MaxIter: maximum number of iterations to find a solution.
%        epsg: maximum acceptable Euclidean norm of the gradient of the
%              objective function at the solution found.
%        epsx: minimum relative change in the optimization variables x.
%           x: solution found (row vector of length n).
%        Iter: number of iterations needed to find the solution.
%     FunEval: number of function evaluations needed.
%          EF: exit flag,
%              EF=1: successful optimization (gradient is small enough).
%              EF=2: algorithm converged (relative change in x is small 
%                    enough).
%              EF=-1: maximum number of iterations exceeded.

%  C) Quasi-Newton optimization algorithm using (BFGS)                  %

function [x,i,FunEval,EF]= Quasi_Newton (fun, x0, MaxIter, epsg, epsx) 
%   Variable Declaration 
 xi        = zeros(MaxIter+1,size(x0,2));
 xi(1,:)   = x0;
 Bi        = eye(size(x0,2));

%  CG algorithm
FunEval = 0;
EF = 0;

  for i = 1:MaxIter

      %Calculate Gradient around current point
      [GradOfU,Eval] =  Grad (fun, xi(i,:));
      FunEval        =  FunEval + Eval;       %Update function evaluation

      %Calculate search direction 
      di             = -Bi\GradOfU ;

      %Calculate Alfa via exact line search 
      [alfa, Eval]   =  LineSearchAlfa(fun,xi(i,:),di);      
      FunEval        =  FunEval + Eval;       %Update function evaluation

      %Calculate Next solution of X    
      xi(i+1,:)      =  xi(i,:) + (alfa*di)';
      
      % Calculate Gradient of X on i+1
      [Grad_Next, Eval] =  Grad (fun, xi(i+1,:));
      FunEval           =  FunEval + Eval;       %Update function evaluation
      
      %Calculate new Beta value using BFGS algorithm            
      Bi                =  BFGS(fun,GradOfU,Grad_Next,xi(i+1,:),xi(i,:), Bi);         
                
      % Calculate maximum acceptable Euclidean norm of the gradient
      if norm(Grad_Next,2) < epsg
          EF        = 1;
          break
      end
      
      % Calculate minimum relative change in the optimization variables
      E            =   xi(i+1,:)- xi(i,:);
      if norm(E,2) < epsx
          EF       = 2;
          break
      end
  end
  % report optimum solution
   x    = xi(i+1,:);
  
  if i == MaxIter
  % report Exit flag that MaxNum of iterations reach      
     EF =  -1;
  end
  
  % report MaxNum of iterations reach  
  Iter  = i;
  
end