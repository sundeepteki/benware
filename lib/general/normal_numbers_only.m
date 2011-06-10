function x = normal_numbers_only(x)
  x = x(:);
  tok = true(1,L(x));
  tok(isnan(x)) = false;
  tok(isinf(x)) = false;
  tok(~(imag(x)==0)) = false;
  x = x(tok);