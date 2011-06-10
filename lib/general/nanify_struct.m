function s = nanify_struct(s)
  % s = nanify_struct(s)
  %
  % returns s, but with all the fields turned to nans
  
  fields = fieldnames(s);
  for ff=1:L(fields)
    fi = fields{ff};
    s.(fi) = nan;
  end