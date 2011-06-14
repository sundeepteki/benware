function [spikeTimes,index] = appendSpikes(spikeTimes,data,dataIndex,index,spikeFilter,threshold)

global fs_in;

maxlen = min(dataIndex);

if maxlen-index<(fs_in*2)
  fprintf('Skipping spike detection\n');
  return;
end

nChan = size(data,1);

newSpikeTimes = findSpikesFast(data(:,index+1:maxlen)',spikeFilter,fs_in,threshold);

for chan = 1:nChan
  spikeTimes{chan} = [spikeTimes{chan}; newSpikeTimes{chan}];
end

index = maxlen;
