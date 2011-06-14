function grid = chooseGrid

d = dir('grids/grid_*.m');

fprintf('Choose a grid:\n');
for ii = 1:length(d)
  fprintf([ num2str(ii) '. ' d(ii).name(6:end-2) '\n']);
end
idx = demandnumberinput(['Enter 1-' num2str(length(d)) ': '],1:length(d));
grid = feval(str2func(d(idx).name(1:end-2)));
