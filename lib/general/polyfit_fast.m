function [p,S] = polyfit_fast(x,y,n)

if ~isequal(size(x),size(y))
    error('MATLAB:polyfit:XYSizeMismatch',...
          'X and Y vectors must be the same size.')
end

x = x(:);
y = y(:);

% Construct Vandermonde matrix.
V(:,n+1) = ones(length(x),1,class(x));
for j = n:-1:1
   V(:,j) = x.*V(:,j+1);
end

% Solve least squares problem.
[Q,R] = qr(V,0);
% ws = warning('off','all');    % skip for speed
p = R\(Q'*y);    % Same as p = V\y;

% the part below is skipped for speed

% warning(ws);
% if size(R,2) > size(R,1)
%    warning('MATLAB:polyfit:PolyNotUnique', ...
%        'Polynomial is not unique; degree >= number of data points.')
% elseif warnIfLargeConditionNumber(R)
%     if nargout > 2
%         warning('MATLAB:polyfit:RepeatedPoints', ...
%                 ['Polynomial is badly conditioned. Add points with distinct X\n' ...
%                  '         values or reduce the degree of the polynomial.']);
%     else
%         warning('MATLAB:polyfit:RepeatedPointsOrRescale', ...
%                 ['Polynomial is badly conditioned. Add points with distinct X\n' ...
%                  '         values, reduce the degree of the polynomial, or try centering\n' ...
%                  '         and scaling as described in HELP POLYFIT.']);
%     end
% end

if nargout==1
  
  p = p.';          % Polynomial coefficients are row vectors by convention.
  S = [];
  
else

  r = y - V*p;
  p = p.';          % Polynomial coefficients are row vectors by convention.


  % S is a structure containing three elements: the triangular factor from a
  % QR decomposition of the Vandermonde matrix, the degrees of freedom and
  % the norm of the residuals.
  S.R = R;
  S.df = max(0,length(y) - (n+1));
  S.normr = norm(r);
end
  
% function flag = warnIfLargeConditionNumber(R)
% if isa(R, 'double')
%     flag = (condest(R) > 1e+10);
% else
%     flag = (condest(R) > 1e+05);
% end
