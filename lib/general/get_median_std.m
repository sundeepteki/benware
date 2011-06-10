function s = get_median_std(data)

  data = nonnans(data);
  ms = bootstrp(1000,@median,data);
  s = std(ms);
    