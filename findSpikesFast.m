function spikeTimes = findSpikesFast(data, spikeFilter, fs, threshold, deadTime)
% spikeTimes = findSpikesFast(data, spikeFilter, fs, threshold, deadTime)
%
% Becoming obsolete

% initialise spiketimes
spikeTimes = cell(1, size(data, 2));

% if we do not have enough data
if size(data, 1) < (2*deadTime + 3)
  return
end

% filter signal
sig = filtfilt(spikeFilter.B, spikeFilter.A, data);

% normalise
nSamples = size(sig, 1);
nChannels = size(sig, 2);
sigMean = repmat(mean(sig, 1), nSamples, 1);
sigStd = repmat(std(sig, [], 1), nSamples, 1);
sig = (sig - sigMean) ./ sigStd - threshold;

% find threshold crossings
sig = sign(sig(deadTime:end-deadTime, :));
sig = diff(sig)<0;

% find the spikeTimes
for chan = 1:nChannels
  spikeTimes{chan} = (find(sig(:, chan)) + deadTime - 1) / fs * 1000;
end
