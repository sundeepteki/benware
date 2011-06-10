function x = zero_to_nan(x)
  x(x==0) = nan;
end