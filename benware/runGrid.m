function runGrid(hardware, expt, grid, firstSweep)
% runGrid(hardware, expt, grid)
% 
% Run a whole grid

tic;

global state;

% start recording a log
diary(constructDataPath([expt.dataDir expt.logFilename], grid, expt));

%% Begin recording
% =================

fprintf_title('Preparing to record');

hardware.dataDevice.setAudioMonitorChannel(state.audioMonitor.channel);

% close open files if there is an error or ctrl-c
cleanupObject = onCleanup(@()cleanup(hardware));

% make filter for spike detection
spikeFilter = makeSpikeFilter(expt.dataDeviceSampleRate);

% upload first stimulus
[nextStim sweeps(firstSweep).stimInfo] = prepareStimulus(...
  grid.stimGenerationFunction, firstSweep, grid, expt);

fprintf('  * Uploading first stimulus...');
uploadWholeStim(hardware.stimDevice, nextStim);
fprintf(['done after ' num2str(toc) ' sec.\n']);

% set up plot
if isfield(grid, 'sweepLength')
  nSamplesExpected = floor(grid.sweepLength*expt.dataDeviceSampleRate)+1;
elseif isfield(grid, 'maxSweepLength')
  nSamplesExpected = floor(grid.maxSweepLength*expt.dataDeviceSampleRate)+1;
else
  nSamplesExpected = floor((size(nextStim,2)/grid.sampleRate+grid.postStimSilence)*expt.dataDeviceSampleRate)+1;
end

if ~isfield(state, 'onlineData')
  state.onlineData = onlineDataInit(expt.dataDeviceSampleRate, expt.nChannels, nSamplesExpected, grid);
end

plotData = plotInit(expt.dataDeviceSampleRate, expt.nChannels, nSamplesExpected, grid);

%% run sweeps
% =============

sweepNum = firstSweep;
while sweepNum<=grid.nSweepsDesired
  tic;
  
  stim = nextStim;
  displayStimInfo(sweeps, grid, sweepNum);
  fprintf('Progress:\n');
  
  % retrieve the stimulus for the NEXT sweep
  isLastSweep = (sweepNum == grid.nSweepsDesired);
  if ~isLastSweep
    [nextStim, sweeps(sweepNum+1).stimInfo] = prepareStimulus(grid.stimGenerationFunction, ...
                                                              sweepNum+1, grid, expt);
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
  
  % get filenames for saving data
  sweeps(sweepNum).dataFiles = constructDataPaths([expt.dataDir expt.dataFilename],grid,expt,sweepNum,expt.nChannels);
  dataDir = split_path(sweeps(sweepNum).dataFiles{1});
  if grid.saveWaveforms
    mkdir_nowarning(dataDir);
  end
  
  % run the sweep
  [nSamples, spikeTimes, lfp, timeStamp, plotData] = ...
      runSweep(hardware, sweepLen, expt.nChannels, stim, nextStim, ...
              spikeFilter, expt.spikeThreshold, grid.saveWaveforms, sweeps(sweepNum).dataFiles, plotData);

  % check whether sweep was successful; if not, offer to repeat it
  if state.noData.warnUser
    if isfield(state, 'justWarnOnDataEmpty') && state.justWarnOnDataEmpty
      % then just warn, don't make a fuss
      fprintf_title('Some incoming channels are empty -- perhaps your Medusa batteries ran out?');
    else
      % then pause, warn the user properly, and offer to do something
      bbeep;
      fprintf_title('Some incoming channels are empty -- perhaps your Medusa batteries ran out?');
      in = lower(demandinput('Do you want to repeat the sweep (fix the problem first!), carry on anyway, or quit? [R/c/q] ','rcq','r',true));
      if in=='c'
        % carry on anyway; don't warn again
        state.noData.alreadyWarned = true;
        state.noData.warnUser = false;
      elseif in=='q'
        % quit.
        % this will leave the last sweep of waveform data on disk. perhaps this shouldn't happen, though
        % if the user has quit, she probably doesn't care much
        state.userQuit = true;
      else
        % repeat the sweep -- reset the warning, and go on to th next iteration of the while loop without
        % saving any more data (though waveforms will usually already have been saved by runGrid)
        % don't update sweepNum, so that sweep is repeated;
        state.noData.warnUser = false;
        continue;
      end
    end
  end

  sweeps(sweepNum).spikeTimes = spikeTimes;
  sweeps(sweepNum).timeStamp = timeStamp;
  
  % store sweep duration
  sweeps(sweepNum).sweepLen.samples = nSamples;
  sweeps(sweepNum).sweepLen.ms = sweeps(sweepNum).sweepLen.samples/expt.dataDeviceSampleRate*1000;
  
  % save sweep metadata
  saveSingleSweepInfo(sweeps(sweepNum), grid, expt, sweepNum);

  % update online data -- LFP
  %updateOnlineLFP(lfp);
  %updateOnlinePSTHes(
  %state.data.nSweeps = sweepNum;
  % state.data.lfp = updateLFP
  %plotData.nSweeps = plotData.nSweeps + 1;
  %plotData = plotUpdateLFP(plotData, lfp);
  
  %plotData.lastSweepSpikes = sweeps(sweepNum).spikeTimes;

  setIdx = grid.randomisedGridSetIdx(sweepNum);
  onlineDataUpdate(setIdx, sweeps(sweepNum).spikeTimes, lfp);

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

  % successfully on to the next sweep
  sweepNum = sweepNum + 1;
end

% cleanup seems to happen on quit anyway, not sure why
%cleanup(hardware);
visualBellOff;

if ~state.userQuit && isfield(state, 'bugle') && state.bugle
  [snd, fs] = wavread(['sounds/bugle-' num2str(randi(3),'%02d') '.wav']);
  soundsc(snd, fs);
end
