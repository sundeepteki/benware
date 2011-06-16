function [data, nSamples, spikeTimes, timeStamp] = runSweep(sweepLen, stim, nextStim, plotFunctions, detectSpikes, spikeFilter, spikeThreshold)
%% Run a sweep, ASSUMING THAT THE STIMULUS HAS ALREADY BEEN UPLOADED
%% Upload the next stimulus at the same time, then reset the stimDevice
%% and inform the stimDevice of the stimulus length


global zBus stimDevice dataDevice;
global fs_in fs_out;
global fakedata;

% reset data device and tell it how long the sweep will be
resetDataDevice(sweepLen*1000);

% check for stale data in data device buffer
if any(countAllData() ~= 0)
  error('Stale data in data buffer');
end

% check that the correct stimulus is in the stimDevice buffer
sz = size(stim, 2);
rnd = floor(100+rand*(sz-300));
checkData = [downloadStim(0, 100) downloadStim(rnd, 100) downloadStim(sz-100, 100)];
d = max(max(abs(checkData - [stim(:, 1:100) stim(:, rnd+1:rnd+100) stim(:, end-99:end)])));

if d>10e-7
  fprintf('Stimulus mismatch!\n');
  keyboard;
end

%keyboard;
% make matlab buffer for data
nSamplesExpected = ceil(sweepLen*fs_in)+1; % actually, we may get one fewer than this
data = zeros(32, nSamplesExpected);
index = zeros(1, 32);

% cell array for storing spike times
spikeTimes = cell(1, 32);
spikeIndex = 0;

%spikeThreshold = -3;

% keep track of how much of stimulus has been uploaded
stimIndex = 0;

% prepare data display
%plotData = feval(plotFunctions.init, []);
plotData = feval(plotFunctions.init, [], nSamplesExpected);

% trigger stimulus presentation and data collection
timeStamp = clock;
triggerZBus();

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

while any(index~=index(1)) || (nSamplesExpected-index(1)>2)
  maxStimIndex = getStimIndex;
  if ~isempty(nextStim)
    if stimIndex==(size(nextStim, 2)-1)
      fprintf(['  * Next stimulus uploaded after ' num2str(toc) ' sec.\n']);
    elseif maxStimIndex>stimIndex
      uploadStimulus(nextStim(:, stimIndex+1:maxStimIndex), stimIndex);
      stimIndex = maxStimIndex;
    end
    %stimIndex
  end
  for chan = 1:32
    newdata = downloadData(chan, index(chan));
    if isempty(fakedata) % I.E. NOT using fakedata
      data(chan, index(chan)+1:index(chan)+length(newdata)) = newdata;
    end
    index(chan) = index(chan)+length(newdata)-1;
  end  

  if detectSpikes
    [spikeTimes, spikeIndex] = appendSpikes(spikeTimes, data, index, spikeIndex, spikeFilter, spikeThreshold, false);
    %sp
  end
  
  plotData = feval(plotFunctions.plot, plotData, data, index, spikeTimes);
  drawnow;
end

fprintf(['  * Sweep done after ' num2str(toc) ' sec.\n']);
plotData = feval(plotFunctions.plot, plotData, data, index, spikeTimes);

if ~isempty(nextStim)
  if stimIndex~=(size(nextStim, 2)-1)
    uploadStimulus(nextStim(:, stimIndex+1:end), stimIndex);
    fprintf(['  * Next stimulus uploaded after ' num2str(toc) ' sec.\n']);
  end
end

if detectSpikes
  [spikeTimes, spikeIndex] = appendSpikes(spikeTimes, data, index, spikeIndex, spikeFilter, spikeThreshold,true);
%spikeTimes
  fprintf(['  * Spikes detected after ' num2str(toc) ' sec.\n']);
end

% check all channels have the same amount of data
nSamples = unique(index+1);
if length(nSamples)>1
  error('Different amounts of data from different channels');
end

fprintf(['  * Got ' num2str(nSamples) ' samples (expecting ' num2str(nSamplesExpected) ') from 32 channels (' num2str(nSamples/fs_in) ' sec).\n']);

% check that we got approximately the expected amount of data
% we'll accept one sample fewer than we expected, but no extra samples
if (nSamples>nSamplesExpected) || (nSamples-nSamplesExpected)>1
  fprintf(['  * Got ' num2str(nSamples) ' samples, expecting ' num2str(nSamplesExpected)]);
  error('Wrong amount of data');
end

resetStimDevice;

global checkdata
if checkdata
  fprintf('  * Checking stim...');
  teststim = downloadStim(0, size(nextStim, 2));
  d = max(max(abs(nextStim-teststim)));
  if d>10e-7
    keyboard
    error('Stimulus mismatch!');
  end
  fprintf([num2str(size(teststim, 2)) ' samples verified.\n']);
  fprintf('  * Checking data...');
  testdata = downloadAllData();
  for chan = 1:32
    d = max(abs(data{chan}(1:nSamples)-testdata{chan}(1:nSamples)));
    if d>0
      error('Data mismatch!');
    end
  end
  fprintf([num2str(nSamples) ' samples verified.\n']);
  fprintf(['  * done after ' num2str(toc) ' sec.\n']);
end
