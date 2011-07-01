function tdt = runGrid(tdt, expt, grid)
% tdt = runGrid(tdt, expt, grid)
% 
% Run a whole grid

%% stim/data setup: AUTO
% =======================

global state;

% close open files if there is an error or ctrl-c
cleanupObject = onCleanup(@()cleanup(tdt));

% gain of scope trace and other UI variables
if ~exist('state','var')
  state = struct;
end
state.plot.enabled = true;
state.plot.onlyActiveChannel = false;
state.plot.waveform = true;
state.plot.filtered = false;
state.plot.lfp = false;
state.plot.raster = false;
if ~isfield(state, 'dataGain')
  state.dataGain = 100;
end
if ~isfield(state, 'audioMonitor') || ~isfield(state.audioMonitor, 'channel')
  state.audioMonitor.channel = 1;
end
state.audioMonitor.changed = true;
state.shouldPause = false;
state.paused = false;

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

tdt = prepareTDT(tdt, expt, grid);

% make filter for spike detection
spikeFilter = makeSpikeFilter(expt.dataDeviceSampleRate);

clear sweeps stim nextStim sweepNum data sweepLen spikeTimes; % no longer needed now this is a function?

% upload first stimulus
[nextStim sweeps(1).stimInfo] = stimGenerationFunction(1, grid, expt);
fprintf('  * Uploading first stimulus...');
uploadWholeStim(tdt.stimDevice, nextStim);
fprintf(['done after ' num2str(toc) ' sec.\n']);

% set up plot -- FIXME assumes all stimuli will be the same length as the first
nSamplesExpected = floor((size(nextStim,2)/grid.sampleRate+grid.postStimSilence)*expt.dataDeviceSampleRate)+1;
plotData = feval(expt.plotFunctions.init, [], expt.dataDeviceSampleRate, nSamplesExpected);
%plotData = [];

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
  
  sweeps(sweepNum).sweepNum = sweepNum;
  
  % store stimulus duration
  sweeps(sweepNum).stimLen.samples = size(stim, 2);
  sweeps(sweepNum).stimLen.ms = sweeps(sweepNum).stimLen.samples/grid.sampleRate*1000;
  
  % actual sweep length
  sweepLen = size(stim, 2)/grid.sampleRate + grid.postStimSilence;
  fprintf(['  * sweep length: ' num2str(sweepLen) ' s\n']);
  
  % get filenames for saving data
  sweeps(sweepNum).dataFiles = constructDataPaths([expt.dataDir expt.dataFilename],grid,expt,sweepNum,32);
  dataDir = split_path(sweeps(sweepNum).dataFiles{1});
  mkdir_nowarning(dataDir);
  
  % run the sweep
  [nSamples, sweeps(sweepNum).spikeTimes, sweeps(sweepNum).timeStamp, plotData] = runSweep(tdt, sweepLen, stim, nextStim, expt.plotFunctions, ...
    expt.detectSpikes, spikeFilter, expt.spikeThreshold, sweeps(sweepNum).dataFiles, plotData);     %#ok<*SAGROW>
  
  % store sweep duration
  sweeps(sweepNum).sweepLen.samples = nSamples;
  sweeps(sweepNum).sweepLen.ms = sweeps(sweepNum).sweepLen.samples/expt.dataDeviceSampleRate*1000;
  
  % save sweep metadata
  saveSingleSweepInfo(sweeps(sweepNum), grid, expt, sweepNum);
  
  fprintf(['  * Finished sweep after ' num2str(toc) ' sec.\n\n']);
  
  % pause if requested (through key press in main window)
  if state.shouldPause
    state.paused = true;
    fprintf_title('Paused -- press space to continue');
    while state.shouldPause
      pause(0.2);
    end
    state.paused = false;
  end
  
end

diary off

%[snd, fs] = wavread(['sounds/bugle-' num2str(randi(3),'%02d') '.wav']);
%soundsc(snd, fs);
