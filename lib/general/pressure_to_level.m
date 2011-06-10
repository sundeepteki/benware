function lev = pressure_to_level(p)
  p0 = 20 * 10^-6;
  lev = 20 * log10(p/p0);