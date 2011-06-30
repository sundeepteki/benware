function spikeTimes = findSpikes(sig, threshold)
% spikeTimes = findSpikes(sig, threshold)
%
% Find spikes in a previously filtered signal
% Simply finds points at which the signal crosses a threshold defined
% as the mean plus a multiple of the SD.

% normalise
nSamples = size(sig, 1);
sigMean = mean(sig, 1);
sigStd = std(sig, [], 1)
sig = (sig - sigMean) ./ sigStd - threshold;

% find threshold crossings
sig = sign(sig);
sig = diff(sig)<0;

% find the spike times
spikeTimes = find(sig);
