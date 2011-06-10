function col = desaturate(col,proportion)
  % col = desaturate(col,proportion)
  % 
  % col is a RGB
  % proportion is between 0 (white) and 1 (as is)
  
  col = col*proportion + [1 1 1]*(1-proportion);