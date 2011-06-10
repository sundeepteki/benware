function M = rows_without_nans(M)
  % M = rows_without_nans(M)
  
  M = M(~any(isnan(M),2),:);