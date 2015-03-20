function makeVisible(handles)
% function makeVisible(handles)
%
% set the 'visible' property of specified object handles to 'on'

for h = handles(:)'
  if ~isobject(h) || ~strcmp(class(h), 'matlab.graphics.GraphicsPlaceholder')
    set(h, 'visible', 'on');
  end
end

