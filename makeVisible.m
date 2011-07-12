function makeVisible(handles)

for h = handles(:)'
  set(h, 'visible', 'on');
end

