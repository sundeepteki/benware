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

% upload first stimulus
[nextStim sweeps(firstSweep).stimInfo] = grid.stimGenerationFunction(firstSweep, grid, expt);
fprintf('  * Uploading first stimulus...');
uploadWholeStim(tdt.stimDevice, nextStim);
fprintf(['done after ' num2str(toc) ' sec.\n']);

% set up plot
if isfield(grid, 'sweepLength')
  nSamplesExpected = floor(grid.sweepLength*expt.dataDeviceSampleRate)+1;
elseif isfield(grid, 'maxSweepLength')
  nSamplesExpected = floor(grid.maxSweepLength*expt.dataDeviceSampleRate)+1;
else
  nSamplesExpected = floor((size(nextStim,2)/grid.sampleRate+grid.postStimSilence)*expt.dataDeviceSampleRate)+1;
end
plotData = plotInit(expt.dataDeviceSampleRate, expt.nChannels, nSamplesExpected, grid);


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
  if isfield(grid, 'sweepLength')
    % then use a fixed sweep length
    sweepLen = grid.sweepLength;
    % if sweep length < stimulus length, warn user
    if (size(stim, 2)/grid.sampleRate)>sweepLen && ~state.sweepTooShort.userWarned
      bbeep;
      fprintf_title('Stimulus length is longer than sweep length!');
      if lower(demandinput('Do you want to carry on anyway? ','yn','n',true))=='n'
        break;
        state.userQuit = true;
      end
      state.sweepTooShort.userWarned = true;
    end
  else
    % sweep length = stimulus length + post stimulus silence
    sweepLen = size(stim, 2)/grid.sampleRate + grid.postStimSilence;
  end
  fprintf(['  * sweep length: ' num2str(sweepLen) ' s\n']);
  
  % running PSTH
  if ~isfield(state, 'psth')
    state.psth.bins = 0:sweepLen/50:sweepLen;
    state.psth.nReps = zeros(expt.nChannels, grid.nStimConditions);
    state.psth.data = repmat({zeros(1,50)},expt.nChannels, grid.nStimConditions);
  end

  % get filenames for saving data
  sweeps(sweepNum).dataFiles = constructDataPaths([expt.dataDir expt.dataFilename],grid,expt,sweepNum,expt.nChannels);
  dataDir = split_path(sweeps(sweepNum).dataFiles{1});
  if grid.saveWaveforms
    mkdir_nowarning(dataDir);
  end
  
  % run the sweep
  [nSamples, sweeps(sweepNum).spikeTimes, sweeps(sweepNum).timeStamp, ...
    plotData] = runSweep(tdt, sweepLen, expt.nChannels, stim, nextStim, ...
    spikeFilter, expt.spikeThreshold, grid.saveWaveforms, ...
    sweeps(sweepNum).dataFiles, plotData);
  
  % store sweep duration
  sweeps(sweepNum).sweepLen.samples = nSamples;
  sweeps(sweepNum).sweepLen.ms = sweeps(sweepNum).sweepLen.samples/expt.dataDeviceSampleRate*1000;
  
  % save sweep metadata
  saveSingleSweepInfo(sweeps(sweepNum), grid, expt, sweepNum);

  % update the appropriate running PSTHes
  %keyboard
  setIdx = grid.randomisedGridSetIdx(sweepNum);
  for chan = 1:expt.nChannels
    %keyboard
    psth = histc(sweeps(sweepNum).spikeTimes{chan}, state.psth.bins);
    psth = psth(1:end-1);
    %size(psth)
    %keyboard
    if state.psth.nReps(chan, setIdx)==0
      state.psth.data{chan, setIdx} = psth;
      size(state.psth.data{chan, setIdx})
    else 
      state.psth.data{chan, setIdx} = (state.psth.data{chan, setIdx} * state.psth.nReps(chan, setIdx) + psth)/ ...
        (state.psth.nReps(chan, setIdx)+1);
      size(state.psth.data{chan, setIdx})
      state.psth.nReps(chan, setIdx) = state.psth.nReps(chan, setIdx) + 1;
    end
  end
  % keyboard
  % try
  %   psth = cell2mat(state.psth.data(1,:)')
  % catch
  %   keyboard;
  % end

  fprintf(['  * Finished sweep after ' num2str(toc) ' sec.\n\n']);
  
  % recreate main figure
%  if rem(sweepNum, 100)==0
%   recreateFigure(101);
%  recreateFigure(103);
% end
  
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
  
  visualBellOff;
end

diary off
visualBellOff;

if ~state.userQuit && isfield(state, 'bugle') && state.bugle
  [snd, fs] = wavread(['sounds/bugle-' num2str(randi(3),'%02d') '.wav']);
  soundsc(snd, fs);
end
