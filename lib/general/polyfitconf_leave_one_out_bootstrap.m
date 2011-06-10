function [xhat yhat yhat_ci_below yhat_ci_above] = polyfitconf_leave_one_out_bootstrap(xx,yy,maxn)
  % [xhat yhat yhat_ci_below yhat_ci_above] = polyfitconf_bootstrap(xx,yy,maxn)

  [xx yy] = nonnans(xx,yy);
  xhat = linspace(min(min(xx),0),max(max(xx),0),1000);
  bootfun = @(z) bootfun_n(z,maxn,xhat);
  
  yhats = bootstrp(1000, bootfun, [xx yy]);
  qs = quantile(yhats,[0.005 0.5 0.995]); 
  yhat = qs(2,:);
  yhat_ci_below = qs(1,:);
  yhat_ci_above = qs(3,:);
    
  
end

function yhat = bootfun_n(z,maxn,xhat)
  b = polyfit_leave_one_out(z(:,1), z(:,2), maxn);
  n = L(b)-1;
  xhat_n = repmat(xhat,n+1,1);
  for ii=0:n
    pow = n-ii;
    row = ii+1;
    xhat_n(row,:) = xhat .^ pow;
  end
  yhat = b*xhat_n;
end
