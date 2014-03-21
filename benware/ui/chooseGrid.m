function grid = chooseGrid
% grid = chooseGrid
% 
% Allows user to choose a grid from the subdirectory grids/

% what is in the directory
l = load('user.mat');
user = l.user;

gridFunctions = dir(fix_slashes(['grids/grids.' user.name '/grid_*.m']));

% scan for new-style stimulus directories in grids/grids.name/stimulus_dirs.txt
fid = fopen(fix_slashes(['grids/grids.' user.name '/stimulus_dirs.txt']));
scan = textscan(fid, '%s', Inf);
fclose(fid);

dirs = scan{1};

% get grids and dirs in same format
allstim = {};
for ii = 1:length(gridFunctions)
  thisstim = struct;
  thisstim.name = gridFunctions(ii).name(6:end-2);
  thisstim.value = gridFunctions(ii).name(1:end-2);
  thisstim.type = 1;
  allstim{end+1} = thisstim;
end

for ii = 1:length(dirs)
  thisstim = struct;
  d = dirs{ii};
  d(d=='\') = '/';
  if d(end)=='/'
    d = d(1:end-1);
  end
  split = strsplit(d, '/');
  thisstim.name = split{end};
  thisstim.value = d;
  thisstim.type = 2;
  allstim{end+1} = thisstim;
end

allstim = [allstim{:}];


% print options for the user
fprintf_subtitle('Choose a grid:');
for ii = 1:length(allstim)
  fprintf('  [%d]: %s\n', ii, allstim(ii).name);
  %fprintf([ num2str(ii) '. ' d(ii).name(6:end-2) '\n']);
end
fprintf('\n');

% demand input
idx = demandnumberinput('      >>> ', 1:L(allstim));
%idx = demandnumberinput(['Enter 1-' num2str(length(d)) ': '],1:length(d));
keyboard
% return the grid
chosenStim = allstim(idx);
if chosenStim.type == 1
  % old-style grid
  funcname = chosenStim.value;
  grid = feval(str2func(funcname));

  % add the name to the grid
  grid.name = funcname(6:end);
else
  % new-style stimulus directory
  grid = getGridForStimDir(chosenStim.value);
end