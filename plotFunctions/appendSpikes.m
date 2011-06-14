function [spikeTimes,index] = appendSpikes(spikeTimes,data,dataIndex,index,spikeFilter,threshold)

global fs_in;

maxlen = min(dataIndex);

if maxlen-index<(fs_in)
  fprintf('Skipping spike finding\n');
  return;
end

nChan = length(data);
%[maxlen index maxlen-index]
datacube = zeros(maxlen-index,nChan);
for chan = 1:nChan
  datacube(:,chan) = data{chan}(index+1:maxlen);
end

newSpikeTimes = findSpikesFast(datacube,spikeFilter,fs_in,threshold);
%newSpikeTimes

for chan = 1:nChan
  spikeTimes{chan} = [spikeTimes{chan}; newSpikeTimes{chan}];
end

index = maxlen;
