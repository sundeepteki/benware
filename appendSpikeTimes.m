function spikeTimes = appendSpikeTimes(spikeTimes, data, offset, fs_in, threshold)

validChans = any(data, 2);

sig = data(validChans,:);

% normalise
nSamples = size(sig, 1);
sigMean = repmat(mean(sig, 1), nSamples, 1);
sigStd = repmat(std(sig, [], 1), nSamples, 1);
sig = (sig - sigMean) ./ sigStd - threshold;

% find threshold crossings
sig = sign(sig(deadTime:end-deadTime, :));
sig = diff(sig)<0;

% append new spike times to spikeTimes
for chan = 1:length(validChans)
  spikeSamples = find(sig(:,chan));
  spikeTimesMs = (offset + spikeSamples) / fs * 1000;
  spikeTimes{validChans(chan)} = [spikeTimes{validChans(chan)}; spikeTimesMs];
end
