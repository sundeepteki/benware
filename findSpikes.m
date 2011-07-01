function spikeTimes = findSpikes(sig, threshold)
% spikeTimes = findSpikes(sig, threshold)
%
% Find spikes in a previously filtered signal
% Simply finds points at which the signal crosses a threshold defined
% as the mean plus a multiple of the SD.

% normalise
sigMean = mean(sig);
sigStd = std(sig);
sig = (sig - sigMean) ./ sigStd - threshold;

% find threshold crossings
sig = sign(sig);
sig = diff(sig)<0;

% find the spike times
spikeTimes = find(sig);
