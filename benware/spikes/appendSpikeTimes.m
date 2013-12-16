function [spikeTimes, waveformStats] = appendSpikeTimes(spikeTimes, data, offset, fs, waveformStats)
% NB threshold is no longer used

global state;

data = data';

validChans = find(any(data, 1));

sig = data(:, validChans);

% normalise
[nSamples, nChannels] = size(sig);
%sigMean = repmat(mean(sig, 1), nSamples, 1);
%sigStd = repmat(std(sig, [], 1), nSamples, 1);
%sig = (sig - sigMean) ./ sigStd - threshold;

FIXEDTHRESHOLD = false;

if FIXEDTHRESHOLD
    % update mn and sd only on the first run of each sweep
    % previously this was done every time which led to artefacts in optogenetic
    % data where artefacts can make the stats vary from moment to moment    
    if isempty(waveformStats)
      statOffset = round(50/1000*fs); % ignore first 50ms because james's current stimuli produce an artefact here (!)
      waveformStats.mn = nan(1, nChannels);
      waveformStats.mn(validChans) = mean(sig(statOffset:end,:), 1);
      waveformStats.sd = nan(1, nChannels);
      waveformStats.sd(validChans) = std(sig(statOffset:end,:), [], 1);  
    end
    
    % speed could probably be improved by doing this arithmetic only once at
    % the start of the sweep -- since mn and sd don't change
    mn = waveformStats.mn(validChans);
    sd = waveformStats.sd(validChans);

else
    % new threshold every time
    mn = mean(sig, 1);
    sd = std(sig, [], 1);
end

for ii = 1:size(sig, 2)
  sig(:,ii) = (sig(:,ii)-mn(ii)) / sd(ii) - state.spikeThreshold;
end

% find threshold crossings
sig = sign(sig);
sig = diff(sig)<0;

% append new spike times to spikeTimes
for chan = 1:length(validChans)
  spikeSamples = find(sig(:,chan));
  spikeTimesMs = (offset + spikeSamples) / fs * 1000;
  spikeTimes{validChans(chan)} = [spikeTimes{validChans(chan)}; spikeTimesMs];
end
