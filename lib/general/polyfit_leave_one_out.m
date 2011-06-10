function [p,s] = polyfit_leave_one_out(x,y,max_order)
  % [p,s] = polyfit_leave_one_out(x,y,max_order=10)
  %
  % determines the correct order of the polynomial using leave-one-out
  % cross validation, and does the same thing that polyfit would usually do
  % at this order

  
% prelims
  if nargin==2
    max_order = 10;
  end

  warning off MATLAB:polyfit:RepeatedPointsOrRescale

% data structures
  poly_e = nan(1,max_order);
  p = cell(1,max_order);
  s = cell(1,max_order);

% calculate error term
  for jj=1:L(poly_e)
    e = nan(size(x));
    for ii=1:L(x)
      tok = [1:(ii-1) (ii+1):L(x)];
      p{jj} = polyfit_fast(x(tok),y(tok),jj);      
      e(ii) = ( polyval(p{jj}, x(ii)) - x(ii) )^2;
    end
    poly_e(jj) = sum(e) / L(x);
  end
  


% best N minimises poly_e  
  [min_e N] = min(poly_e);
  [p,s] = polyfit_fast(x,y,N);

