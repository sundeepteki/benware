function fl = get_fill_lines(xmin, xmax, ymin, ymax, m, spacing)
  % get_fill_lines(xmin, xmax, ymin, ymax, m, spacing)
  
  fl = struct;
      
  if m==0
    n_fl = (ymax - ymin)/spacing;
    for ii=1:n_fl
      fl(ii).x = [xmin xmax];
      fl(ii).y = (ymin + (ii-1)*spacing) * [1 1];
    end
    return
  end
  
  if m==Inf
    n_fl = (xmax - xmin)/spacing;
    for ii=1:n_fl
      fl(ii).x = (xmin + (ii-1)*spacing) * [1 1];
      fl(ii).y = [ymin ymax];
    end    
    return
  end
  
  if m>0
    fl(1).x(1) = xmin - (ymax-ymin)*spacing/m/2;
    fl(1).y(1) = ymin;
    fl(1).y(2) = ymax;
    fl(1).x(2) = fl(1).x(1) + 1/m * (fl(1).y(2)-fl(1).y(1));
  
    for ii=2:100
      fl(ii).x(1) = fl(ii-1).x(1) + spacing;
      fl(ii).y(1) = ymin;
      fl(ii).y(2) = ymax;
      fl(ii).x(2) = fl(ii).x(1) + 1/m * (fl(ii).y(2)-fl(ii).y(1));
    end
    
    for ii=1:L(fl)
      if fl(ii).x(1)<xmin
        fl(ii).x(1) = xmin;        
        fl(ii).y(1) = fl(ii).y(2) - m*(fl(ii).x(2)-fl(ii).x(1));
      end
      if fl(ii).x(2)>xmax
        fl(ii).x(2) = xmax;
        fl(ii).y(2) = fl(ii).y(1) + m*(fl(ii).x(2)-fl(ii).x(1));
        fl = fl(1:ii);
        return;
      end
    
    end
  end
      
  
  