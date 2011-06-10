function xc = get_xc(obj)
  xc = get(obj,'position');
  xc = xc(1) + xc(3)/2;
end
  
  