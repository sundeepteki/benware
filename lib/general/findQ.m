function Q = findQ(wf,qratio)
  
  % normalise
    %wf = (wf / max(abs(wf))).^2;
    wf = (wf / max((wf))).^2;
  
  % find the maximum
    [maxwf maxpos] = max(wf);

  % move up from the maximum
    w = [nan nan];
    for ii=(maxpos+1):L(wf)
      if wf(ii) < qratio
        w(2) = ii;
        break;
      end
    end
  % move down from the maximum  
    for ii=(maxpos-1):-1:1
      if wf(ii) < qratio
        w(1) = ii;
        break;
      end
    end
    
  % how wide is this
    if all(isnan(w))
      Q = nan;
      return;
    end
  
    if ~isnan(w(1)) && isnan(w(2))
      w(2) = maxpos + (maxpos-w(1));
    end
    
    if isnan(w(2)) && ~isnan(w(1))
      w(1) = maxpos - (w(2)-maxpos);
    end
            
    if ~any(isnan(w))
      Q = w(2)-w(1)+1;
      return;
    end
    
end
    
    