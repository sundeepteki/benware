function grid = chooseGrid(stimDir)
% grid = chooseGrid(stimDir)
% 
% Allows user to choose a grid from the subdirectory grids/

% what is in the directory
l = load('user.mat');
user = l.user;

% get functions from grids/grids.user/ and put relevant information in allstim
gridFunctions = dir(fix_slashes(['grids/grids.' user.name '/grid_*.m']));
allstim = {};
for ii = 1:length(gridFunctions)
  thisstim = struct;
  thisstim.name = gridFunctions(ii).name(6:end-2);
  thisstim.value = gridFunctions(ii).name(1:end-2);
  thisstim.type = 1;
  allstim{end+1} = thisstim;
end

% scan for stimulus directories in stimDir and put information in allstim
if ~isempty(stimDir)
  if ~exist(stimDir', 'dir')
    errorBeep(sprintf('Stimulus search directory in expt.stimulusDirectory does not exist: %s', stimDir));
  end

  dirs = dir(stimDir);
  for ii = 1:length(dirs)
    if dirs(ii).isdir && dirs(ii).name(1)~='.'
        d = dirs(ii).name;
        thisstim.name = d;
        thisstim.value = [stimDir filesep d];
        thisstim.type = 2;
        allstim{end+1} = thisstim;
    end
  end
end

[srt, idx] = sort(cellfun(@(x) x.name, allstim, 'uni', false));
allstim = allstim(idx);
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
  grid.name = chosenStim.name;
end