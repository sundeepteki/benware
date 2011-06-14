%% initial setup
% =================

% core variables
global zBus stimDevice dataDevice;
global fs_in fs_out
global channelOrder

fs_in = 24414.0625;

global truncate fakedata checkdata;
truncate = 0; % for testing only. should normally be 0
fakedata = [];%load('fakedata.mat'); % for testing only. should normally be []
checkdata = false; % for testing only. should normally be FALSE

if truncate~=0
    fprintf('Truncating stimuli! This is for testing only!\n');
end
if ~isempty(fakedata)
    fprintf('RECORDING FAKE DATA! this is for testing only!\n');
end
if checkdata
    fprintf('Downloading all data twice! this is for testing only!\n');
end
if truncate~=0 || ~isempty(fakedata) || checkdata
  fprintf('Press a key to continue.\n');
  pause;
end

% path
if ispc
  addpath(genpath('D:\auditory-objects\NeilLib'));
  addpath([pwd '\plotFunctions\']);
  addpath([pwd '\grids']);
else
  addpath([pwd '/../NeilLib/']);
  addpath([pwd '/plotFunctions/']);
  addpath([pwd '/grids/']);
end


%% stim/data setup: USER
% =======================

% experiment details
clear expt grid;

expt.exptNum = 29;
%expt.stimDeviceName = 'RX6';
expt.penetrationNum = 98;
expt.probe.lhs = 9999;
expt.probe.rhs = 9999;
expt.headstage.lhs = 9999;
expt.headstage.rhs = 9999;
channelMapping = [9 8 10 7 13 4 12 5 15 2 16 1 14 3 11 6];
expt.channelMapping = [channelMapping channelMapping+16];
if ispc
    expt.dataDir = 'F:\expt-%E\%P-%N\';
    expt.dataFilename = 'raw.f32\%P.%N.sweep.%S.channel.%C.f32';
else
    expt.dataDir = './expt-%E/%P-%N/';
    expt.dataFilename = 'raw.f32/%P.%N.sweep.%S.channel.%C.f32';
end
expt.plotFunctions.init = 'scopeTraceInit';
expt.plotFunctions.plot = 'scopeTracePlot';
expt.detectSpikes = true;
%expt.plotFunctions.preGrid = 'rasterPreGrid';
%expt.plotFunctions.preSweep = 'rasterPreSweep';
%expt.plotFunctions.plot = 'rasterPlot';

% load grid from grids/ directory
grid = chooseGrid;

%% stim/data setup: AUTO
% =======================

% check that the grid is valid, and that stim files are there
verifyGridFields(grid);
verifyStimFilesExist(grid, expt);

% add extra fields
grid.saveName = '';
grid.nStimConditions = size(grid.stimGrid, 1);

% randomise grid
repeatedGrid = repmat(grid.stimGrid, [grid.repeatsPerCondition, 1]);
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
stimGenerationFunction = str2func(grid.stimGenerationFunctionName);

% save grid metadata
saveGridMetadata(grid, expt);


%% display
% =========

saveDirStr = constructDataPath(expt.dataDir(1:end-1), grid, expt);
saveDirStr = regexprep(saveDirStr, '\', '\\\');
fprintf(['Saving to ' saveDirStr '\n']);

%% make filter for spike detection
spikeFilter = makeSpikeFilter(fs_in);

%% Begin recording
% =================

% prepare TDT
tic;
figure(99);
fs_out = grid.sampleRate;
zBusInit;
%pause(2);
stimDeviceInit('RX6', fs_out);
%pause(2);
dataDeviceInit(expt.channelMapping);
fprintf('Post-initialisation pause...');
pause(2);
fprintf('done.\n');

clear sweeps stim nextStim sweepNum data sweepLen;

% upload first stimulus
tic;
[nextStim sweeps(1).stimInfo] = stimGenerationFunction(1, grid, expt);
fprintf('Uploading first stimulus...');
uploadWholeStim(nextStim);
fprintf(['done after ' num2str(toc) ' sec.\n']);

% run sweeps
for sweepNum = 1:grid.nSweepsDesired
  tic;
  
  stim = nextStim;
  displayStimInfo(sweeps, grid, sweepNum);

  % retrieve the stimulus for the NEXT sweep
  isLastSweep = (sweepNum == grid.nSweepsDesired);
  if ~isLastSweep    
    [nextStim, sweeps(sweepNum+1).stimInfo] = stimGenerationFunction(sweepNum+1, grid, expt);
  else
    nextStim = [];
  end

  % sweep duration in seconds
  sweepLen = size(stim, 2)/fs_out + grid.postStimSilence;
  
  % run the sweep
  [data, sweeps(sweepNum).spikeTimes, sweeps(sweepNum).timeStamp] = runSweep(sweepLen, stim, nextStim,expt.plotFunctions,expt.detectSpikes,spikeFilter);    

  % save this sweep
  saveData(data, grid, expt, sweepNum);
  saveSweepInfo(sweeps, grid, expt);

  fprintf(['Finished sweep after ' num2str(toc) ' sec.\n\n']);
end
