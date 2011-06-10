function M = rows_without_all_nans(M)
  % M = rows_without_all_nans(M)
  
  M = M(~all(isnan(M),2),:);