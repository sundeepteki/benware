function recreateFigure(figNum)

if ~exist('figNum', 'var')
  figNum = gcf;
end

% move children (subplots) to another figure
children = get(figNum, 'children');
figure(110876);
set(110876, 'visible', 'off');
for child = children
  set(child, 'parent', 110876);
end

% store various properties of the figure
properties = {'color', 'renderer', 'KeyPressFcn', 'name', 'numbertitle', ...
              'toolbar', 'menubar', 'position', 'visible'};
values = [];
for ii = 1:length(properties)
  values{ii} = get(figNum, properties{ii});
end

% close figure and open a new one
close(figNum);
figure(figNum);

% restore the subplots to the new figure
children = get(110876, 'children');
for child = children
  set(child, 'parent', figNum);
end

% restore the other properties
for ii = 1:length(properties)
  set(figNum, properties{ii}, values{ii});
end

% close the temporary figure
close(110876);
