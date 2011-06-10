function y = filterset(y,fun)
  % y = filterset(y)  
  %
  % y = y(fun(y))
  
  y = y(fun(y));
  
  