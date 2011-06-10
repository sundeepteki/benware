function sem = nansem(data)
  % sem = nansem(data)
  sem = nanstd(data) ./ sqrt(sum(~isnan(data)));