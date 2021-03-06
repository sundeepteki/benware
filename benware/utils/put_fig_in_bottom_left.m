function put_fig_in_bottom_left(id)
  % put_fig_in_bottom_left
  % put_fig_in_bottom_left(id)
  
  if nargin==0
    id = gcf;
  end
  
  screensize = get(0,'screenSize');
  screen_width  = screensize(3);
  screen_height = screensize(4);
  
  figsize = get(id,'position');
  fig_width = figsize(3);
  fig_height = figsize(4);
  
  figsize(1) = 1;
  figsize(2) = 1;
  set(id,'position',figsize);
  