function onlineDataUpdate(setIdx, spikeTimes, lfpsignal);

global state;

%% update psthes
psth = state.onlineData.psth;

for chan = 1:state.onlineData.nChannels
	newPSTH = histc(spikeTimes{chan}(:)'/1000, psth.edges)';

	% update per-set PSTH
	if psth.nSweeps(setIdx)==0
		psth.data(:, chan, setIdx) = newPSTH;

	else
		% psth.data(:, chan, setIdx) = (psth.data(:, chan, setIdx)*psth.nSweeps(setIdx) + newPSTH) / ...
		% 		(psth.nSweeps(setIdx)+1);
		psth.data(:, chan, setIdx) = psth.data(:, chan, setIdx) + newPSTH;

	end

	% update pooled PSTH
	if psth.nPooledSweeps==0
		psth.pooledData(:, chan) = newPSTH;

	else
		% psth.pooledData(:, chan) = (psth.pooledData(:, chan, setIdx)*psth.nPooledSweeps(setIdx) + newPSTH) / ...
		% 		(psth.nPooledSweeps(setIdx)+1);
		psth.pooledData(:, chan) = psth.pooledData(:, chan) + newPSTH;

	end

end
psth.nSweeps(setIdx) = psth.nSweeps(setIdx) + 1;
psth.nPooledSweeps = psth.nPooledSweeps + 1;

state.onlineData.psth = psth;

%% update LFP
lfp = state.onlineData.lfp;

if lfp.nSweeps==0
	lfp.sum = lfpsignal(:, lfp.samplesToKeep);
else
    [nChannels, maxSample] = size(lfpsignal);
    if maxSample>=max(lfp.samplesToKeep)
        lfp.sum = lfp.sum + lfpsignal(:, lfp.samplesToKeep);
    else
        downsampled = lfpsignal(:, lfp.samplesToKeep(lfp.samplesToKeep<=maxSample));
        downsampled = [downsampled zeros(nChannels, length(lfp.samplesToKeep)-size(downsampled, 2))];
        lfp.sum = lfp.sum + downsampled;
    end
end
lfp.nSweeps = lfp.nSweeps + 1;

state.onlineData.lfp = lfp;
