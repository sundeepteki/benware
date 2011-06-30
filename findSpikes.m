function spikeTimes = findSpikes(sig, threshold)

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
