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

mn = mean(sig, 1);
sd = std(sig, [], 1);

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
