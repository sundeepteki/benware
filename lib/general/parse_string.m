function substrs = parse_string(str,delim)
  % substrs = parse_string(str)
  
  substrs = {};
  while 1
    [t str] = strtok(str,delim);
    if isempty(t)
      return;
    end
    substrs = [substrs t];
  end