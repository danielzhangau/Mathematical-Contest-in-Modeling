function B=cal_B(y,h,n)
  B=zeros(n,1);
  for i=2:n-1
      B(i)=6*((y(i+1)-y(i))/h(i)-(y(i)-y(i-1))/h(i-1));
  end
end