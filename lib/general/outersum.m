function z = outersum(x,y,varargin)
  % z = outersum(x,y)
  %   produces a L(x)*L(y) matrix
  %   where elements are the sums of xs and ys (combinatorically)
  %
  % z = outersum(x,y,':') 
  %   produces a L(x)L(y)*1 matrix
  
  x = x(:);
  y = y(:)';
  n = struct;
  n.x = L(x);
  n.y = L(y);
  x = repmat(x,1,n.y);
  y = repmat(y,n.x,1);
  z = x+y;
  
  if nargin==3
    z = z(:);
  end