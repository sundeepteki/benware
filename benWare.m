%% initial setup
% =================

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

% welcome
printGreetings()

% core variables
global zBus stimDevice dataDevice;
global fs_in fs_out
global channelOrder
global dataGain

fs_in = 24414.0625;

global truncate fakedata checkdata;
truncate = 0; % for testing only. should normally be 0
fakedata = []; %load('fakedata.mat'); % for testing only. should normally be []
checkdata = false; % for testing only. should normally be FALSE

% testing notices
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




%% stim/data setup: USER
% =======================

% experiment details
clear expt grid;

expt.exptNum = 30;
% fs_in and fs_out should be stored here or in grid.foo
%expt.stimDeviceName = 'RX6';
expt.penetrationNum = 8;
expt.probe.lhs = 2849;
expt.probe.rhs = 2940;
expt.headstage.lhs = 3455;
expt.headstage.rhs = 3078;
channelMapping = [9 8 10 7 13 4 12 5 15 2 16 1 14 3 11 6];
expt.channelMapping = [channelMapping channelMapping+16];

if ispc
    expt.dataDir = 'F:\auditory-objects.data\expt%E\%P-%N\';
    expt.dataFilename = 'raw.f32\%P.%N.sweep.%S.channel.%C.f32';
else
    expt.dataDir = './expt-%E/%P-%N/';
    expt.dataFilename = 'raw.f32/%P.%N.sweep.%S.channel.%C.f32';
end
expt.logFilename = 'benWare.log';
expt.plotFunctions.init = 'scopeTraceFastInit';
expt.plotFunctions.plot = 'scopeTraceFastPlot';
expt.dataGain = 0.5e-3;
expt.detectSpikes = true;
expt.spikeThreshold = -2.8;
%expt.plotFunctions.preGrid = 'rasterPreGrid';
%expt.plotFunctions.preSweep = 'rasterPreSweep';
%expt.plotFunctions.plot = 'rasterPlot';

% load grid from grids/ directory
grid = chooseGrid();

%% stim/data setup: AUTO
% =======================

% gain of scope trace
dataGain = expt.dataGain;

% check that the grid is valid
verifyGridFields(grid);

% check that stim files are there, if needed
if isequal(grid.stimGenerationFunctionName, 'loadStereo')
  verifyStimFilesExist(grid, expt);
end

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

% start recording a log
diary(constructDataPath([expt.dataDir expt.logFilename], grid, expt));

%% Begin recording
% =================

fprintf_title('Preparing to record');
tic;

% make filter for spike detection
spikeFilter = makeSpikeFilter(fs_in);

% prepare TDT
figure(99);
set_fig_size(100, 100, 99);
put_fig_in_bottom_right;
fs_out = grid.sampleRate;
zBusInit();
%pause(2);
stimDeviceInit('RX6', fs_out);
%pause(2);
dataDeviceInit(expt.channelMapping);
fprintf('  * Post-initialisation pause...');
pause(2);
fprintf('done.\n');

clear sweeps stim nextStim sweepNum data sweepLen;
tic;

% upload first stimulus
[nextStim sweeps(1).stimInfo] = stimGenerationFunction(1, grid, expt);
fprintf('  * Uploading first stimulus...');
uploadWholeStim(nextStim);
fprintf(['done after ' num2str(toc) ' sec.\n']);


%% run sweeps
% =============

for sweepNum = 1:grid.nSweepsDesired
  tic;
  
  stim = nextStim;
  displayStimInfo(sweeps, grid, sweepNum);
  fprintf('Progress:\n');

  % retrieve the stimulus for the NEXT sweep
  isLastSweep = (sweepNum == grid.nSweepsDesired);
  if ~isLastSweep    
    [nextStim, sweeps(sweepNum+1).stimInfo] = stimGenerationFunction(sweepNum+1, grid, expt);
  else
    nextStim = [];
  end

  % store stimulus duration
  sweeps(sweepNum).stimLen.samples = size(stim, 2);
  sweeps(sweepNum).stimLen.ms = sweeps(sweepNum).stimLen.samples/fs_out*1000;
  % actual sweep length
  sweepLen = size(stim, 2)/fs_out + grid.postStimSilence;
  fprintf(['  * sweep length: ' num2str(sweepLen) ' s\n']);
  
  % run the sweep
  [data, nSamples, sweeps(sweepNum).spikeTimes, sweeps(sweepNum).timeStamp] = runSweep(sweepLen, stim, nextStim, expt.plotFunctions, expt.detectSpikes, spikeFilter, expt.spikeThreshold);     %#ok<*SAGROW>
  
  % store sweep duration
  sweeps(sweepNum).sweepLen.samples = nSamples;
  sweeps(sweepNum).sweepLen.ms = sweeps(sweepNum).sweepLen.samples/fs_in*1000;
  
  % save this sweep
  saveData(data, grid, expt, sweepNum, nSamples);
  saveSweepInfo(sweeps, grid, expt);

  fprintf(['  * Finished sweep after ' num2str(toc) ' sec.\n\n']);
end

diary off