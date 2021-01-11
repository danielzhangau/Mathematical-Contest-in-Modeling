% dsolve('Dy=3*x^2','x')

% dsolve('Dy=3*x^2','y(0)=2','x')

[x y] = dsolve('Dx=y,D2y-Dy=0','x(0)=2,y(0)=1,Dy(0)=1')
