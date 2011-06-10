function invC = safeinv(C)

  if ~size(C,1)==size(C,2)
    error('input:error','C is not square');
  end
  
  N = size(C,1);
  scalefactor   = exp(-logdet(C)/N);
  scaled_C      = C * scalefactor; 
  scaled_invC   = inv(scaled_C);
  invC = scaled_invC * scalefactor;
  
end
