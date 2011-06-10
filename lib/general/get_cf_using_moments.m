function [cf bw] = get_cf_using_moments(w,varargin)
  % cf = get_cf_using_moments(w)
  % cf = get_cf_using_moments(w,'plot')
  % [cf bw] = get_cf_using_moments(...)

  % parse input w
  if L(w)==34
  elseif L(w)==35
    w = droptail(w);
  elseif isstruct(w)
    w = droptail(w.f);
  end

  % plot?
  plot_cf = false;
  if nargin>1
    if ismember('plot',varargin)
      plot_cf = true;
    end
  end

  % angles
  th = (1:34)'/34 * 2 * pi;  
  
  % mean
  th2 = circ_mean(th,w.^2);
  if th2<0, th2=th2+2*pi; end
  cf = th2/(2*pi)*34;
  
  % std
  th3 = circ_std(th,w.^2);
  if th3<0, th3=th3+2*pi; end
  bw = th3/(2*pi)*34;

  % plot
  if plot_cf
    
      % weighted average
      wi = exp(1i*th) .* (w.^2);
      wit = sum(wi);
  
    figure;
    ax(1) = axatpos(0.4,0.75,1,2,1,1);
    hold on;
    plot(wi,'o-');
    plot([0 wit],'r-');
    
    plot([0 abs(wit)/2 * exp(1i * (th2+th3))],'r--');
    plot([0 abs(wit)/2 * exp(1i * (th2-th3))],'r--');

    ax(2) = axatpos(0.4,0.75,1,2,1,2);
    hold on;
    plot(w);
    plot(cf*[1 1],ylim,'r--');
    xlim([0.5 34.5]);
  end