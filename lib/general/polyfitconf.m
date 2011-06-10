function varargout = polyfitconf(xx,yy,n,xhat)
  % yhat                      = ...
  % [yhat dyhat]              = ...
  % [yhat dyhat b covb]       = ...
  % [yhat dyhat b covb]       = polyfitconf(xx,yy,n,xhat)
  % [yhat dyhat b covb xhat]  = polyfitconf(xx,yy,n,xhat)
  %
  % can omit xhat

  if nargin<4
    xhat = minmax(xx(:)');
  end
  
  [b covb] = polyfit(xx,yy,n);
  [yhat dyhat] = polyconf(b, xhat, covb, 'predopt', 'curve', 'alpha', 0.01);
  
  if nargout>0
    varargout{1} = yhat;
  end
  if nargout>1
    varargout{2} = dyhat;
  end
  if nargout>2
    varargout{3} = b;
  end
  if nargout>3
    varargout{4} = covb;
  end
  if nargout>4
    varargout{5} = xhat;
  end