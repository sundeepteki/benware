function [xhat yhat yhat_ci_below yhat_ci_above] = polyfitconf_bootstrap(xx,yy,varargin)
  % [xhat yhat yhat_ci_below yhat_ci_above] = polyfitconf_bootstrap(xx,yy,n)
  % [xhat yhat yhat_ci_below yhat_ci_above] = polyfitconf_bootstrap(xx,yy,n,xhat)

  [xx yy] = nonnans(xx,yy);
  
  if nargin==3
    n = varargin{1};
    xhat = linspace(min(min(xx),0),max(max(xx),0),1000);
  elseif nargin==4
    n = varargin{1};
    xhat = varargin{2};
  end
  
  
 
  bootfun = @(z) bootfun_n(z,n,xhat);
  
  yhats = bootstrp(1000, bootfun, [xx yy]);
  qs = quantile(yhats,[0.005 0.5 0.995]); 
  yhat = qs(2,:);
  yhat_ci_below = qs(1,:);
  yhat_ci_above = qs(3,:);
    
  
end

function yhat = bootfun_n(z,n,xhat)
  b = polyfit(z(:,1), z(:,2), n);
  xhat_n = repmat(xhat,n+1,1);
  for ii=0:n
    pow = n-ii;
    row = ii+1;
    xhat_n(row,:) = xhat .^ pow;
  end
  yhat = b*xhat_n;
end
