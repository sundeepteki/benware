function sweepTimes = spikesamples2sweeptimes(f_s, spikeTimes, sweepLens)

if isempty(spikeTimes)
  sweepTimes = [];
return;
end

spikeTimes = double(spikeTimes);

% biggest spike time should be less than biggest sample
assert(max(spikeTimes)<sum(sweepLens));


% convert spike times to sweep times
sweepEdges = [0 cumsum(sweepLens)];
sweepStarts = sweepEdges(1:end-1);
sweepEnds = sweepEdges(2:end);

nSpikes = length(spikeTimes);
sweepTimes = nan(nSpikes, 2);
for ii = 1:nSpikes
  sweepTimes(ii, 1) = find(spikeTimes(ii)>=sweepStarts & spikeTimes(ii)<sweepEnds);
  sweepTimes(ii, 2) = (spikeTimes(ii)-sweepStarts(sweepTimes(ii, 1)))/f_s;
end
