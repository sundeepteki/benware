function [spikeTimes,index] = appendSpikes(spikeTimes,data,dataIndex,index,spikeFilter,threshold)

global fs_in;

maxlen = min(dataIndex);

if maxlen-index<(fs_in)
  %fprintf('Skipping spike finding\n');
  return;
end

nChan = length(data);
%[maxlen index maxlen-index]
datacube = zeros(maxlen-index,nChan);
for chan = 1:nChan
  datacube(:,chan) = data{chan}(index+1:maxlen);
end

%keyboard;
validChans = find(sum(datacube)>0);
newSpikeTimes = findSpikesFast(datacube(:,validChans),spikeFilter,fs_in,threshold);
%newSpikeTimes

for ii = 1:length(newSpikeTimes)
  if length(newSpikeTimes{ii})>((maxlen-index)/fs_in)*1000
    fprintf(['Too many spikes on channel ' num2str(validChans(ii)) '. Ignoring.\n']);
  else
    spikeTimes{validChans(ii)} = [spikeTimes{validChans(ii)}; newSpikeTimes{ii}];
  end
end

index = maxlen;
