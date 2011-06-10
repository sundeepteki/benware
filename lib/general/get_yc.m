function yc = get_yc(obj)
  yc = get(obj,'position');
  yc = yc(2) + yc(4)/2;
end
  
  