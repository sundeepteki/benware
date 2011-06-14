function [spikeTimes,index] = appendSpikes(spikeTimes,data,dataIndex,index,spikeFilter,threshold)

global fs_in;

maxlen = min(dataIndex);

if maxlen-index<(fs_in)
  return;
end

datacube = data(:,index+1:maxlen)';
validChans = find(sum(datacube)>0);
newSpikeTimes = findSpikesFast(datacube(:,validChans),spikeFilter,fs_in,threshold);

for ii = 1:length(newSpikeTimes)
  if length(newSpikeTimes{ii})>((maxlen-index)/fs_in)*1000
    fprintf(['Too many spikes on channel ' num2str(validChans(ii)) '. Ignoring.\n']);
  else
    spikeTimes{validChans(ii)} = [spikeTimes{validChans(ii)}; newSpikeTimes{ii}];
  end
end

index = maxlen;
