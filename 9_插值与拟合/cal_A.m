function A=cal_A(h,n)
A=zeros(n,n);
A(1,1)=1;
A(n,n)=1;
  for i=2:n-1
      A(i,i-1)=h(i-1);
      A(i,i)=2*(h(i-1)+h(i));
      A(i,i+1)=h(i);
  end      
end