function r = contiguous_region_about_x(list, x)
  % r = contiguous_region_about_x(list, x)
  %
  % reduces the list to be a contiguous region about x, of course
  
  minval = 1;
  maxval = max([list(:)' x])+1;
  
  lo = max(setdiff(minval:x, list))+1;
  hi = min(setdiff(x:maxval, list))-1;
  
  r = lo:hi;