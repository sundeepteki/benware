function nm = cummax(n)
  % num = cummax(n)
  % cumulative maximum
  
  if ~(min(size(n))==1)
    error('input:error','only accepts row or column vectors');
  end
  
  
  nm = nan(size(n));
  for ii=1:L(n)
    nm(ii) = max(n(1:ii));
  end
end