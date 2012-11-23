function makeVisible(handles)
% function makeVisible(handles)
%
% set the 'visible' property of specified object handles to 'on'

for h = handles(:)'
  set(h, 'visible', 'on');
end

