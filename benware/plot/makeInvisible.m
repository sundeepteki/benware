function makeInvisible(handles)
% function makeInvisible(handles)
%
% set the 'visible' property of specified object handles to 'off'

for h = handles(:)'
  if ~isobject(h) || ~strcmp(class(h), 'matlab.graphics.GraphicsPlaceholder')
    set(h, 'visible', 'off');
  end
end

