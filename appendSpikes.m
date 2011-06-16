function [spikeTimes,index] = appendSpikes(spikeTimes,data,dataIndex,index,spikeFilter,threshold,force)

global fs_in;

maxlen = min(dataIndex);

if ~force && (maxlen-index<(fs_in))
  return;
end

% our filtering doesn't deal well with the ends of the signal
% so we need to exclude any spikes found at the beginning and end,
% and overlap chunks so that the whole signal is processed.
deadTime = 50; % this is a function of spikeFilter, and should really be stored with spikeFilter itself

datacube = data(:,index+1:maxlen)';
validChans = find(sum(abs(datacube))>0);
newSpikeTimes = findSpikesFast(datacube(:,validChans),spikeFilter,fs_in,threshold,deadTime);

for ii = 1:length(newSpikeTimes)
  if length(newSpikeTimes{ii})>((maxlen-index)/fs_in)*1000
    fprintf(['Too many spikes on channel ' num2str(validChans(ii)) '. Ignoring.\n']);
  else
    spikeTimes{validChans(ii)} = [spikeTimes{validChans(ii)}; newSpikeTimes{ii}+index/fs_in*1000];
  end
end

% chunks need to overlap by twice the filter dead time.
index = maxlen-deadTime*2;
