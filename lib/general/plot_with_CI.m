function p = plot_with_CI(x,y,ci_below, ci_above,col)
  % p = plot_with_error(x,y,ci_below,ci_above)
  % p = plot_with_error(x,y,ci_below,ci_above,,color)
  %
  % simple function for pretty plotting [ci_below,ci_above] as a function of x
  
  if nargin==4
    col = 'b';
  end
  
  hold on;
  
  x = x(:)';
  y = y(:)';
  ci_below = ci_below(:)';  
  ci_above = ci_above(:)';  
  minval = min(ci_below);
  
  % area plot
  p.a = area(x, [ci_below; ci_above-ci_below]', minval, 'facecolor', col, 'linestyle', 'none');
  set(p.a(1),'visible','off');
  p.a = p.a(2);
  set(get(p.a,'children'),'faceAlpha',0.25);
  
  
  % line plot
  p.l = plot(x, y, 'linewidth',4, 'color', col);
  