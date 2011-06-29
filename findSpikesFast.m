function [spikeTimes, filteredData] = findSpikesFast(data, spikeFilter, fs, threshold, deadTime)

% initialise spiketimes
spikeTimes = cell(1, size(data, 2));

% if we do not have enough data
if size(data, 1) < (2*deadTime + 3)
  return
end

% filter signal
filteredData = filtfilt(spikeFilter.B, spikeFilter.A, data);

% normalise
nSamples = size(filteredData, 1);
nChannels = size(filteredData, 2);
sigMean = repmat(mean(filteredData, 1), nSamples, 1);
sigStd = repmat(std(filteredData, [], 1), nSamples, 1);
sig = (filteredData - sigMean) ./ sigStd - threshold;

% find threshold crossings
sig = sign(sig(deadTime:end-deadTime, :));
sig = diff(sig)<0;

% find the spikeTimes
for chan = 1:nChannels
  spikeTimes{chan} = (find(sig(:, chan)) + deadTime - 1) / fs * 1000;
end
