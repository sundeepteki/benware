function makeInvisible(handles)

for h = handles(:)'
  set(h, 'visible', 'off');
end

