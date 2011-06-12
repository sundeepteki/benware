%% initial setup
% =================

% core variables
global zBus stimDevice dataDevice;
global fs_in fs_out
global channelOrder

fs_in = 24414.0625;

global truncate checkdata;
truncate = 20; % for testing only. should normally be 0
checkdata = false; % for testing only. should normally be FALSE

% path
if ispc
  addpath(genpath('D:\auditory-objects\NeilLib'));
  addpath([pwd '\grids']);
else
  addpath([pwd '/../NeilLib/']);
  addpath([pwd '/grids']);
end

% filename tokens:
% %E = expt number, e.g. '29'
% %1, %2... %9 = stimulus parameter value
% %N = grid name
% %L = left or right (for stimulus file)
% %P = penetration number
% %S = sweep number
% %C = channel number


%% stim/data setup: USER
% =======================

% experiment details
expt.exptNum = 29;
expt.penetrationNum = 98;
expt.probe.lhs = 9999;
expt.probe.rhs = 9999;
expt.headstage.lhs = 9999;
expt.headstage.rhs = 9999;
channelMapping = [9 8 10 7 13 4 12 5 15 2 16 1 14 3 11 6];
expt.channelMapping = [channelMapping channelMapping+16];

% load grid
grid = grid_test();


%% stim/data setup: AUTO
% =======================

% check that the grid is valid, and that stim files are there
verifyGridFields(grid);
verifyStimFilesExist(grid, expt);

% add extra fields
grid.altName = '';
grid.nStimConditions = size(grid.stimGrid, 1);
%grid.dataDir = 'F:\expt-%E\%P-%N\';
%grid.dataFilename = 'raw.f32\%P.%N.sweep.%S.channel.%C.f32';
grid.dataDir = '/data/expt-%E/%P-%N/';
grid.dataFilename = 'raw.f32/%P.%N.sweep.%S.channel.%C.f32';

% randomise grid
repeatedGrid = repmat(grid.stimGrid, [grid.repeatsPerCondition, 1]);
grid.nSweepsDesired = size(repeatedGrid, 1);
grid.randomisedGrid = repeatedGrid(randperm(grid.nSweepsDesired), :);
[junk grid.randomisedGridSetIdx] = ...
    ismember(grid.randomisedGrid, grid.stimGrid, 'rows');

% verify that we have the right conditions from the user
verifyExpt(grid, expt);

% check for existence of data directory. 
% If it does exist, use grid.altName to store alternative name.
grid.altName = verifySaveDir(grid, expt);

% stimulus generation function handle
stimGenerationFunction = str2func(grid.stimGenerationFunctionName);

% save grid metadata
saveGridMetadata(grid, expt);


%% display
% =========

saveDirStr = constructDataPath(grid.dataDir(1:end-1), grid, expt);
saveDirStr = regexprep(saveDirStr, '\', '\\\');
fprintf(['Saving to ' saveDirStr '\n']);


%% Begin recording
% =================

% prepare TDT
tic;
fs_out = grid.sampleRate;
zBusInit;
stimDeviceInit('RX6', fs_out);
dataDeviceInit;
pause(2);

clear sweeps;

% upload first stimulus
tic;
[stim sweeps(1).stimInfo] = stimGenerationFunction(1, grid, expt);
uploadWholeStim(stim);

% run sweeps
for sweepNum = 1:grid.nSweepsDesired
  tic;
  displayStimInfo(sweeps, grid, sweepNum);

  % retrieve the next stimulus
  isLastSweep = (sweepNum == grid.nSweepsDesired);
  if ~isLastSweep
    [nextStim, sweeps(sweepNum+1).stimInfo] = ...
	stimGenerationFunction(sweepNum+1, grid, expt);
  else
    nextStim = [];
  end

  % sweep duration in seconds
  sweepLen = size(stim, 2)/fs_out + grid.postStimSilence;
  % run the sweep
  [data, sweeps(sweepNum).timeStamp] = ...
      runSweep(sweepLen, nextStim, expt.channelMapping);    
  % save this sweep
  saveData(data, grid, expt, sweepNum);
  saveSweepInfo(sweeps, grid, expt);

  fprintf(['Finished sweep after ' num2str(toc) ' sec.\n\n']);
end
