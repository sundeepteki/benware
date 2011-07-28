function grid = prepareGrid(grid, expt)

% check that the grid is valid
verifyGridFields(grid);

% check that stim files are there, if needed
if isequal(grid.stimGenerationFunctionName, 'loadStereo')
  verifyStimFilesExist(grid, expt);
end

% add extra fields
grid.saveName = '';
grid.nStimConditions = size(grid.stimGrid, 1);

if isfield(grid, 'initFunction')
  grid = feval(grid.initFunction, grid, expt);
end

if ~isfield(grid, 'saveWaveforms')
  grid.saveWaveforms = true;
end

if isfield(grid, 'sweepLen') && isfield(grid, 'postStimSilence')
  error('grid:error', 'Grid specifies both sweepLen and postStimSilence');
end

% randomise grid
if isfinite(grid.repeatsPerCondition)
  repeatsPerCondition = grid.repeatsPerCondition;
else
  repeatsPerCondition = 10000;
end
repeatedGrid = repmat(grid.stimGrid, [repeatsPerCondition, 1]);
grid.nSweepsDesired = size(repeatedGrid, 1);
grid.randomisedGrid = repeatedGrid(randperm(grid.nSweepsDesired), :);
[junk grid.randomisedGridSetIdx] = ...
  ismember(grid.randomisedGrid, grid.stimGrid, 'rows');

% verify that we have the right conditions from the user
verifyExpt(grid, expt);

% check for existence of data directory.
% If it does exist, use grid.saveName to store alternative name.
grid.saveName = verifySaveDir(grid, expt);

% stimulus generation function handle
grid.stimGenerationFunction = str2func(grid.stimGenerationFunctionName);

% save grid metadata
saveGridMetadata(grid, expt);