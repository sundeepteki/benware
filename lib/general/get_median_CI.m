function [ci_lo ci_hi] = get_median_CI(data)

  data = nonnans(data);
  ms = bootstrp(1000,@median,data);
  cis = quantile(ms,[0.5 99.5]/100);
  ci_lo = cis(1);
  ci_hi = cis(2);
    