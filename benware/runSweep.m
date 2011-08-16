function [nSamples, spikeTimes, timeStamp, plotData] = runSweep(tdt, ...
  sweepLen, nChannels, stim, nextStim, spikeFilter, spikeThreshold, ...
  saveWaveforms, dataFiles, plotData)
  %% Run a sweep, ASSUMING THAT THE STIMULUS HAS ALREADY BEEN UPLOADED
  %% Will fail if next stimulus is not on the TDT
  %% Upload the next stimulus at the same time, then reset the stimDevice
  %% and inform the stimDevice of the stimulus length

  global state;

  % reset data device and tell it how long the sweep will be
  resetDataDevice(tdt.dataDevice, sweepLen*1000);

  % check for stale data in data device buffer
  if any(countAllData(tdt.dataDevice, nChannels) ~= 0)
    errorBeep('Stale data in data buffer');
  end

  % check that the correct stimulus is in the stimDevice buffer
  nStimChans = size(stim, 1);
  stimLen = size(stim, 2);
  rnd = floor(100+rand*(stimLen-300));
  
  checkData = [downloadStim(tdt.stimDevice, 0, 100, nStimChans) ...
      downloadStim(tdt.stimDevice, rnd, 100, nStimChans) ...
      downloadStim(tdt.stimDevice, stimLen-100, 100, nStimChans)];
  
  d = max(max(abs(checkData - [stim(:, 1:100) stim(:, rnd+1:rnd+100) stim(:, end-99:end)])));

  if d>10e-7
    keyboard;
    errorBeep('Stimulus on stimDevice is not correct!');
  end

  % check stimulus length is correct
  if getStimLength(tdt.stimDevice) ~= stimLen
    errorBeep('Stimulus length on stimDevice is not correct');
  end

  % record length of next stimulus for uploading
  nextStimLen = size(nextStim, 2);

  % reset stimulus device so it reads out from the beginning of the buffer
  % when triggered
  % probably not necessary (since circuit resets itself)
  % replace with a check that it is in correct state?
  resetStimDevice(tdt.stimDevice);
  if getStimIndex(tdt.stimDevice)~=0
    errorBeep('Stimulus index not equal to zero at start of sweep');
  end

  % make matlab buffer for data
  nSamplesExpected = floor(sweepLen*tdt.dataSampleRate)+1;
  data = zeros(nChannels, nSamplesExpected);
  nSamplesReceived = zeros(1, nChannels);

  filteredData = zeros(nChannels, nSamplesExpected);
  filterIndex = 0;
  
  % open data files
  if saveWaveforms
    dataFileHandles = nan(1,nChannels);
    for chan = 1:nChannels
      dataFileHandles(chan) = fopen(dataFiles{chan},'w');
    end
  end
  
  % cell array for storing spike times
  spikeTimes = cell(1, nChannels);

  % keep track of how much of stimulus has been uploaded
  samplesUploaded = 0;

  % prepare data display
  %plotData = feval(plotFunctions.init, [], tdt.dataSampleRate, nSamplesExpected);
  %plotData = feval(plotFunctions.reset, plotData);

  % trigger stimulus presentation and data collection
  timeStamp = clock;
  triggerZBus(tdt.zBus);

  fprintf(['  * Sweep triggered after ' num2str(toc) ' sec.\n']);

  plotData = plotReset(plotData);

  
  % while trial is running:
  % * upload next stimulus as far as possible
  % * download data as fast as possible while trial is running
  % * plot incoming data

  % loop until we've received all data
  while any(nSamplesReceived~=nSamplesExpected)
    
    % upload stimulus
    if ~isempty(nextStim)
      % stimulus upload is limited by length of stimulus, or where the
      % stimDevice has got to in reading out the stimulus, whichever is lower
      maxStimIndex = min(getStimIndex(tdt.stimDevice),nextStimLen);
      n = samplesUploaded + 1;
      if maxStimIndex>samplesUploaded
        uploadStim(tdt.stimDevice, nextStim(:, samplesUploaded+1:maxStimIndex), samplesUploaded);
        samplesUploaded = maxStimIndex;
        if samplesUploaded==nextStimLen
          fprintf(['  * Next stimulus uploaded after ' num2str(toc) ' sec.\n']);
        end
      end
    
    end
    %fprintf(['  * Stim: ' num2str((maxStimIndex-n)/tdt.stimSampleRate) ' sec of stim done in ' num2str(toc) ' sec.\n']);tic;
    
    % download data
    for chan = 1:nChannels

      newdata = downloadData(tdt.dataDevice, chan, nSamplesReceived(chan));
      data(chan, nSamplesReceived(chan)+1:nSamplesReceived(chan)+length(newdata)) = newdata;
      
      nSamplesReceived(chan) = nSamplesReceived(chan)+length(newdata);
      if saveWaveforms
        fwrite(dataFileHandles(chan), newdata, 'float32');
      end
      
    end
    
    %fprintf(['  * Data: ' num2str(length(newdata)/tdt.dataSampleRate) ' sec of data done in ' num2str(toc) ' sec.\n']);tic;

    % bandpass filter data and detect spikes

    minSamplesReceived = min(nSamplesReceived);
    if (minSamplesReceived-filterIndex) > (tdt.dataSampleRate/10)
      [filtData, offset] = filterData(data(:, filterIndex+1:minSamplesReceived), spikeFilter);
      filteredData(:, filterIndex+offset+1:filterIndex+offset+size(filtData,2)) = filtData;
      spikeTimes = appendSpikeTimes(spikeTimes, filtData, filterIndex+offset+1, tdt.dataSampleRate, spikeThreshold);
      filterIndex = filterIndex + size(filtData,2);
    end
        
     %fprintf(['  * filtering done after ' num2str(toc) ' sec.\n']);tic;
 
    % check audio monitor is on the right channel
    if state.audioMonitor.changed
      setAudioMonitorChannel(tdt, state.audioMonitor.channel);
      state.audioMonitor.changed = false;
    end

    % plot data
    plotData = plotUpdate(plotData, data, nSamplesReceived, filteredData, filterIndex, spikeTimes);
 
    %fprintf(['  * draw done after ' num2str(toc) ' sec.\n']);tic;

  end

  fprintf(['  * Waveforms received and saved after ' num2str(toc) ' sec.\n']);

  if ~isempty(nextStim)
    % finish uploading stimulus if necessary
    if samplesUploaded~=nextStimLen
      uploadStim(tdt.stimDevice, nextStim(:, samplesUploaded+1:end), samplesUploaded);
      samplesUploaded = nextStimLen;
      fprintf(['  * Next stimulus uploaded after ' num2str(toc) ' sec.\n']);
    end

    % inform stimDevice about length of the stimulus that has been uploaded
    % (i.e. the stimulus for the next sweep)
    setStimLength(tdt.stimDevice, nextStimLen);
  end

  % finish detecting spikes  
  [filtData, offset] = filterData(data(:, filterIndex+1:minSamplesReceived), spikeFilter);
  filteredData(:, filterIndex+offset+1:filterIndex+offset+size(filtData,2)) = filtData;
  spikeTimes = appendSpikeTimes(spikeTimes, filtData, filterIndex+offset+1, tdt.dataSampleRate, spikeThreshold);
  filterIndex = filterIndex + size(filtData,2);
  
  fprintf(['  * ' num2str(sum(cellfun(@(i) length(i),spikeTimes))) ' spikes detected after ' num2str(toc) ' sec.\n']);

  % final plot
  plotData = plotUpdate(plotData, data, nSamplesReceived, filteredData, filterIndex, spikeTimes);
  plotData.lastSweepSpikes = spikeTimes;

  % close data files
  if saveWaveforms
    for chan = 1:nChannels
      fclose(dataFileHandles(chan));
    end
  end

  % check for blank data channels
  if ~state.noData.alreadyWarned && ~isempty(data) &&  any(all(data==0,2))
    state.noData.warnUser = true;
  end

  % data integrity check:
  % 1. check all channels have the same amount of data
  nSamples = unique(nSamplesReceived);
  if length(nSamples)>1
    errorBeep('Different amounts of data from different channels');
  end

  fprintf(['  * Got ' num2str(nSamples) ' samples (expecting ' num2str(nSamplesExpected) ') from ' num2str(nChannels) ' channels (' num2str(nSamples/tdt.dataSampleRate) ' sec).\n']);

  % 2. check that we got the expected number of samples
  if (nSamples~=nSamplesExpected)
    errorBeep('Wrong number of samples');
  end

  % optional: check data thoroughly (too slow to be used normally)
  global checkdata

  if checkdata
    
    fprintf('  * Checking stim...');
    teststim = downloadStim(tdt.stimDevice, 0, samplesUploaded, nStimChans);
    d = max(max(abs(nextStim-teststim)));
    if d>10e-7
      errorBeep('Stimulus mismatch!');
    end
    fprintf([' ' num2str(size(teststim, 2)) ' samples verified.\n']);

    if ~saveWaveforms
      fprintf('No waveforms saved -- can''t check waveform data\n');
    
    else
      fprintf('  * Checking data...');
      testData = downloadAllData(tdt.dataDevice, nChannels);
      for chan = 1:nChannels
        diffInMem = max(abs(data(chan,:) - testData{chan}));
        if diffInMem > 0
          errorBeep('Data in memory doesn''t match TDT buffer!');
        end

        h = fopen(dataFiles{chan}, 'r');
        savedData = fread(h, inf, 'float32')';
        fclose(h);
        diffOnDisk = max(abs(savedData - testData{chan}));
        if diffOnDisk > 0
          keyboard;
          errorBeep('Data on disk doesn''t match TDT buffer!');
        end

      end
      fprintf([' ' num2str(nSamples) ' samples verified.\n']);
    end
    
    fprintf(['  * Check complete after ' num2str(toc) ' sec.\n']);
  end
