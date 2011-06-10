function x = onlyfinite(x)
  % x = onlyfinite(x)
  %
  % keeps only the finite (not NaN or +/- inf) elements of x
  
  x = x(isfinite(x));
end