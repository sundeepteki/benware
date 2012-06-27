function makeInvisible(handles)
% function makeInvisible(handles)
%
% set the 'visible' property of specified object handles to 'off'

for h = handles(:)'
  set(h, 'visible', 'off');
end

