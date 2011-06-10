function varargout = wlsq(X,Y,W)
  % WLSQ
  %
  % [b b_cov] = wlsq(X,Y,W) 
  % ------------------------
  % performs weighted least squares regression. also returns the
  % covariance matrix.
  %
  % [b b_cov mse] = wlsq(X,Y,W)
  % ------------------------------------------------
  % also calculates the mean-squared-error for leave-one-out
  % cross-validation
  
  
  B     = (X'*W*X) \ (X'*W*Y);
  B_cov = (Y'*W*Y - Y'*W*X*((X'*W*X)\(X'*W*Y))) / abs(diff(size(X))) * inv(X' * W * X);

	varargout{1} = B;
  varargout{2} = B_cov;

  
%% leave-one-out cross-validation
% =================================

  if nargout==3

    mse = 0;
    N = size(X,1);
    for ii=1:N;
      tokeep = [1:(ii-1) (ii+1):N];
      Xt = X(tokeep,:);
      Yt = Y(tokeep,:);
      Wt = W(tokeep,tokeep);
      Bt = (Xt'*Wt*Xt) \ (Xt'*Wt*Yt);
      mse = mse + W(ii,ii) * (Y(ii) - (X(ii,:) * Bt)).^2;
    end
    mse = mse / N;

    varargout{3} = mse;
        
  end