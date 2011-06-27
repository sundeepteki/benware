function [nSamples, spikeTimes, timeStamp] = runSweep(stimDevice, fs_out, dataDevice, fs_in, zBus, sweepLen, stim, nextStim, plotFunctions, detectSpikes, spikeFilter, spikeThreshold, dataFiles)
%% Run a sweep, ASSUMING THAT THE STIMULUS HAS ALREADY BEEN UPLOADED
%% Will fail if next stimulus is not on the TDT
%% Upload the next stimulus at the same time, then reset the stimDevice
%% and inform the stimDevice of the stimulus length

global fakedata;

% reset data device and tell it how long the sweep will be
resetDataDevice(dataDevice, sweepLen*1000);

% check for stale data in data device buffer
if any(countAllData(dataDevice) ~= 0)
  error('Stale data in data buffer');
end

% check that the correct stimulus is in the stimDevice buffer
sz = size(stim, 2);
rnd = floor(100+rand*(sz-300));
checkData = [downloadStim(stimDevice, 0, 100) downloadStim(stimDevice, rnd, 100) downloadStim(stimDevice, sz-100, 100)];
d = max(max(abs(checkData - [stim(:, 1:100) stim(:, rnd+1:rnd+100) stim(:, end-99:end)])));

if d>10e-7
  error('Stimulus on stimDevice is not correct!');
end

% reset stimulus device so it reads out from the beginning of the buffer
% when triggered
resetStimDevice(stimDevice);

% make matlab buffer for data
nSamplesExpected = floor(sweepLen*fs_in)+1;
data = zeros(32, nSamplesExpected);
nSamplesReceived = zeros(1, 32);

% open data files
dataFileHandles = nan(1,32);
for chan = 1:32
  dataFileHandles(chan) = fopen(dataFiles{chan},'w');
end

% cell array for storing spike times
spikeTimes = cell(1, 32);
spikeIndex = 0;

% keep track of how much of stimulus has been uploaded
stimIndex = 0;

% prepare data display
%plotData = feval(plotFunctions.init, []);
plotData = feval(plotFunctions.init, [], fs_in, nSamplesExpected);

% trigger stimulus presentation and data collection
timeStamp = clock;
triggerZBus(zBus);

fprintf('  * Sweep triggered.\n');

% while trial is running:
% * upload next stimulus as far as possible
% * download data as fast as possible while trial is running
% * plot incoming data

if ~isempty(fakedata)
  for chan = 1:32
    data{chan} = rand(1, nSamplesExpected)/5000;
  end
  data{1}(1:size(fakedata.signal, 1)) = fakedata.signal(:, floor(rand*size(fakedata.signal, 2)+1));
end

% loop until we've received all data
while any(nSamplesReceived~=nSamplesExpected)

  % upload stimulus
  maxStimIndex = getStimIndex(stimDevice);
  if ~isempty(nextStim)
    if stimIndex==(size(nextStim, 2)-1)
      fprintf(['  * Next stimulus uploaded after ' num2str(toc) ' sec.\n']);
    elseif maxStimIndex>stimIndex
      uploadStimulus(stimDevice, nextStim(:, stimIndex+1:maxStimIndex), stimIndex);
      stimIndex = maxStimIndex;
    end
  end

  % download data
  for chan = 1:32
    newdata = downloadData(dataDevice, chan, nSamplesReceived(chan));
    if isempty(fakedata) % I.E. NOT using fakedata
      data(chan, nSamplesReceived(chan)+1:nSamplesReceived(chan)+length(newdata)) = newdata;
    end
    nSamplesReceived(chan) = nSamplesReceived(chan)+length(newdata);
    fwrite(dataFileHandles(chan), newdata, 'float32');
  end

  % detect spikes
  [spikeTimes, spikeIndex] = appendSpikes(spikeTimes, fs_in, data, nSamplesReceived, spikeIndex, spikeFilter, spikeThreshold, false);

  % plot data
  plotData = feval(plotFunctions.plot, plotData, data, nSamplesReceived, spikeTimes);
  drawnow;
end

fprintf(['  * Waveforms received and saved after ' num2str(toc) ' sec.\n']);

% finish uploading stimulus if necessary
if ~isempty(nextStim)
  if stimIndex~=(size(nextStim, 2)-1)
    uploadStimulus(stimDevice, nextStim(:, stimIndex+1:end), stimIndex);
    fprintf(['  * Next stimulus uploaded after ' num2str(toc) ' sec.\n']);
  end
end

% finish detecting spikes
if detectSpikes
  [spikeTimes, spikeIndex] = appendSpikes(spikeTimes, fs_in, data, nSamplesReceived, spikeIndex, spikeFilter, spikeThreshold,true);
  fprintf(['  * ' num2str(sum(cellfun(@(i) length(i),spikeTimes))) ' spikes detected after ' num2str(toc) ' sec.\n']);
end

% final plot
plotData = feval(plotFunctions.plot, plotData, data, nSamplesReceived, spikeTimes);
drawnow;

% close data files
for chan = 1:32
  fclose(dataFileHandles(chan));
end

% data integrity check:
% 1. check all channels have the same amount of data
nSamples = unique(nSamplesReceived);
if length(nSamples)>1
  error('Different amounts of data from different channels');
end

fprintf(['  * Got ' num2str(nSamples) ' samples (expecting ' num2str(nSamplesExpected) ') from 32 channels (' num2str(nSamples/fs_in) ' sec).\n']);

% 2. check that we got the expected number of samples
if (nSamples~=nSamplesExpected)
  error('Wrong number of samples');
end

% optional: check data thoroughly (too slow to be used normally)
global checkdata

if checkdata
  fprintf('  * Checking stim...');
  teststim = downloadStim(stimDevice, 0, size(nextStim, 2));
  d = max(max(abs(nextStim-teststim)));
  if d>10e-7
    error('Stimulus mismatch!');
  end
  fprintf([' ' num2str(size(teststim, 2)) ' samples verified.\n']);

  fprintf('  * Checking data...');
  testData = downloadAllData(dataDevice);
  for chan = 1:32
    diffInMem = max(abs(data(chan,:) - testData{chan}));
    if diffInMem > 0
      error('Data in memory doesn''t match TDT buffer!');
    end

    h = fopen(dataFiles{chan}, 'r');
    savedData = fread(h, inf, 'float32')';
    fclose(h);
    diffOnDisk = max(abs(savedData - testData{chan}));
    if diffOnDisk > 0
      error('Data on disk doesn''t match TDT buffer!');
    end
    
  end
  fprintf([' ' num2str(nSamples) ' samples verified.\n']);
  fprintf(['  * Check complete after ' num2str(toc) ' sec.\n']);
end
