function x = nan_to_zero(x)
  x(isnan(x)) = 0;
end