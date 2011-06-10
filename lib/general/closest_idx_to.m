function varargout = closest_idx_to(x, val)
  % idx       = closest_idx_to(x, val)
  % [idx val] = closest_idx_to(x, val)
  %
  % finds the closest value to a (presumably sorted x) and returns the
  % index (and optionally the value in x itself)
  
  [val idx] = min(abs(x-val));
  
  varargout{1} = idx;
  if nargout==2
    varargout{2} = val;
  end