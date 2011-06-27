%% initial setup
% =================

% path
if ispc
  addpath(genpath('D:\auditory-objects\NeilLib'));
  addpath(genpath(pwd));
else
  addpath([pwd '/../NeilLib/']);
  addpath(genpath(pwd));
end

% welcome
printGreetings()

% core variables
%global zBus stimDevice dataDevice;
%global fs_in fs_out
global dataGain

%expt.fs_in = 24414.0625;
%expt.fs_out = expt.fs_in * 2;

global truncate fakedata checkdata;
truncate = 0; % for testing only. should normally be 0
fakedata = []; %load('fakedata.mat'); % for testing only. should normally be []
checkdata = true; % for testing only. should normally be FALSE

% testing notices
needWarning = false;

if truncate~=0
  fprintf('Truncating stimuli! This is for testing only!\n');
  needWarning = true;
end
if ~isempty(fakedata)
  fprintf('RECORDING FAKE DATA! this is for testing only!\n');
  needWarning = true;
end
if checkdata
  fprintf('Downloading all data twice! this is for testing only!\n');
  needWarning = true;
end

if needWarning
  fprintf('Press a key to continue.\n');
  pause;
end


%% stim/data setup: USER
% =======================

% experiment details
clear expt grid;

expt.exptNum = 98;

expt.stimDeviceName = 'RX6';

expt.dataDeviceName = 'RZ5';
expt.dataDeviceSampleRate = 24414.0625;

expt.penetrationNum = 99;
expt.probe.lhs = 2920;
expt.probe.rhs = 2940;
expt.headstage.lhs = 3455;
expt.headstage.rhs = 3078;
channelMapping = [9 8 10 7 13 4 12 5 15 2 16 1 14 3 11 6];
expt.channelMapping = [channelMapping channelMapping+16];

if ispc
  expt.dataDir = 'F:\auditory-objects.data\expt%E\%P-%N\';
  expt.dataFilename = 'raw.f32\%P.%N.sweep.%S.channel.%C.f32';
  expt.spikeFilename = 'spike.mat\%P.%N.sweep.%S.mat';
else
  expt.dataDir = './expt-%E/%P-%N/';
  expt.dataFilename = 'raw.f32/%P.%N.sweep.%S.channel.%C.f32';
  expt.spikeFilename = 'spike.mat/%P.%N.sweep.%S.mat';
end

expt.logFilename = 'benWare.log';
expt.plotFunctions.init = 'scopeTraceFastInit';
expt.plotFunctions.plot = 'scopeTraceFastPlot';
expt.dataGain = 1000;
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

try
    
  fprintf_title('Preparing to record');
  tic;
  
  % make filter for spike detection
  spikeFilter = makeSpikeFilter(expt.dataDeviceSampleRate);
  
  % prepare TDT
  figure(99);
  set_fig_size(100, 100, 99);
  put_fig_in_bottom_right;

  if ~exist('zBus','var')
    zBus = [];
  end
  zBus = zBusInit(zBus);
  
  if ~exist('stimDevice','var')
    stimDevice = [];
  end
  stimDevice = stimDeviceInit(stimDevice, expt.stimDeviceName, grid.sampleRate);
  
  if ~exist('dataDevice','var')
    dataDevice = [];
  end
  dataDevice = dataDeviceInit(dataDevice, expt.dataDeviceName, expt.dataDeviceSampleRate, expt.channelMapping);
  
  fprintf('  * Post-initialisation pause...');
  pause(2);
  fprintf('done.\n');
  
  clear sweeps stim nextStim sweepNum data sweepLen spikeTimes;
  tic;
  
  % upload first stimulus
  [nextStim sweeps(1).stimInfo] = stimGenerationFunction(1, grid, expt);
  fprintf('  * Uploading first stimulus...');
  uploadWholeStim(stimDevice, nextStim);
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
    sweeps(sweepNum).stimLen.ms = sweeps(sweepNum).stimLen.samples/grid.sampleRate*1000;
    
    % actual sweep length
    sweepLen = size(stim, 2)/grid.sampleRate + grid.postStimSilence;
    fprintf(['  * sweep length: ' num2str(sweepLen) ' s\n']);
    
    % get filenames for saving data
    for chan = 1:32
      sweeps(sweepNum).dataFiles{chan} = constructDataPath([expt.dataDir expt.dataFilename],grid,expt,sweepNum,chan);
    end
    dataDir = split_path(sweeps(sweepNum).dataFiles{chan});
    mkdir_nowarning(dataDir);
    
    % run the sweep
    [nSamples, spikeTimes, sweeps(sweepNum).timeStamp] = runSweep(stimDevice, grid.sampleRate, dataDevice, expt.dataDeviceSampleRate, zBus, sweepLen, stim, nextStim, expt.plotFunctions, expt.detectSpikes, spikeFilter, expt.spikeThreshold,sweeps(sweepNum).dataFiles);     %#ok<*SAGROW>
    
    % store sweep duration
    sweeps(sweepNum).sweepLen.samples = nSamples;
    sweeps(sweepNum).sweepLen.ms = sweeps(sweepNum).sweepLen.samples/expt.dataDeviceSampleRate*1000;
        
    % save spikes separately or as part of sweep info
    sweeps(sweepNum).spikeFile = saveSpikeTimes(spikeTimes, grid, expt, sweepNum);
    
    % save sweep metadata
    saveSweepInfo(sweeps, grid, expt);

    fprintf(['  * Finished sweep after ' num2str(toc) ' sec.\n\n']);
  end
  
  diary off
  
catch ME
  % close open files in the event of an error or ctrl-C
  fprintf('Error -- closing open files\n');
  fclose('all');
  diary off;
  rethrow(ME);
  
end