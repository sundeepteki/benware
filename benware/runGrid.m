function runGrid(tdt, expt, grid, firstSweep)
% runGrid(tdt, expt, grid)
% 
% Run a whole grid

tic;

global state;

% start recording a log
diary(constructDataPath([expt.dataDir expt.logFilename], grid, expt));

%% Begin recording
% =================

fprintf_title('Preparing to record');

setAudioMonitorChannel(tdt, state.audioMonitor.channel);

% close open files if there is an error or ctrl-c
cleanupObject = onCleanup(@()cleanup(tdt));

% make filter for spike detection
spikeFilter = makeSpikeFilter(expt.dataDeviceSampleRate);

%clear sweeps stim nextStim sweepNum data sweepLen spikeTimes; % no longer needed now this is a function?

% upload first stimulus
[nextStim sweeps(firstSweep).stimInfo] = grid.stimGenerationFunction(firstSweep, grid, expt);
fprintf('  * Uploading first stimulus...');
uploadWholeStim(tdt.stimDevice, nextStim);
fprintf(['done after ' num2str(toc) ' sec.\n']);

% set up plot -- FIXME assumes all stimuli will be the same length as the first
nSamplesExpected = floor((size(nextStim,2)/grid.sampleRate+grid.postStimSilence)*expt.dataDeviceSampleRate)+1;
plotData = plotInit(expt.dataDeviceSampleRate, expt.nChannels, nSamplesExpected);


%% run sweeps
% =============

for sweepNum = firstSweep:grid.nSweepsDesired
  tic;
  
  stim = nextStim;
  displayStimInfo(sweeps, grid, sweepNum);
  fprintf('Progress:\n');
  
  % retrieve the stimulus for the NEXT sweep
  isLastSweep = (sweepNum == grid.nSweepsDesired);
  if ~isLastSweep
    [nextStim, sweeps(sweepNum+1).stimInfo] = grid.stimGenerationFunction(sweepNum+1, grid, expt);
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
  sweeps(sweepNum).dataFiles = constructDataPaths([expt.dataDir expt.dataFilename],grid,expt,sweepNum,expt.nChannels);
  dataDir = split_path(sweeps(sweepNum).dataFiles{1});
  mkdir_nowarning(dataDir);
  
  % run the sweep
  [nSamples, sweeps(sweepNum).spikeTimes, sweeps(sweepNum).timeStamp, plotData] = runSweep(tdt, sweepLen, expt.nChannels, stim, nextStim, ...
    spikeFilter, expt.spikeThreshold, sweeps(sweepNum).dataFiles, plotData);     %#ok<*SAGROW>
  
  % store sweep duration
  sweeps(sweepNum).sweepLen.samples = nSamples;
  sweeps(sweepNum).sweepLen.ms = sweeps(sweepNum).sweepLen.samples/expt.dataDeviceSampleRate*1000;
  
  % save sweep metadata
  saveSingleSweepInfo(sweeps(sweepNum), grid, expt, sweepNum);
  
  fprintf(['  * Finished sweep after ' num2str(toc) ' sec.\n\n']);
  
  % pause if requested (through key press in main window)
  if state.shouldPause
    state.paused = true;
    bbeep;
    fprintf_title('Paused -- press space to continue');
    while state.shouldPause
      pause(0.2);
    end
    state.paused = false;
  end
  
  if state.noData.warnUser
    bbeep;
    fprintf_title('Some incoming channels are empty -- perhaps your Medusa batteries ran out?');
    if lower(demandinput('Do you want to carry on anyway? ','yn','n',true))=='y'
      state.noData.alreadyWarned = true;
      state.noData.warnUser = false;
    else
      state.userQuit = true;
    end
  end
  
  if state.userQuit
    bbeep;
    fprintf_title('Do you really want to quit?');
    if lower(demandinput('Do you really want to terminate this grid? ','yn','n',true))=='y'
      break;
    else
      state.userQuit = false;
    end
  end
end

diary off

if ~state.userQuit
  [snd, fs] = wavread(['sounds/bugle-' num2str(randi(3),'%02d') '.wav']);
  soundsc(snd, fs);
end
