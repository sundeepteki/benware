function p = level_to_pressure(lev)
  p0 = 20 * 10^-6;
  p = p0 * 10.^(lev / 20);