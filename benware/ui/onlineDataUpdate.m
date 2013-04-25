function onlineDataUpdate(setIdx, spikeTimes, lfpsignal, sampleWaveforms)

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

%% update Sahani PSTHes and noise ratio
sahani = state.onlineData.sahani;

for chan = 1:state.onlineData.nChannels
	newPSTH = histc(spikeTimes{chan}(:)'/1000, sahani.edges);
    if isempty(sahani.data{chan, setIdx})
        sahani.data{chan, setIdx} = newPSTH;
    else
        sahani.data{chan, setIdx}(end+1, :) = newPSTH;
        [sp, np] = sahani_quick(sahani.data{chan, setIdx});
        sahani.noiseRatio(chan, setIdx) = np/sp;
        sahani.meanNoiseRatio(chan) = min(sahani.noiseRatio(chan, :));
    end
end
% 
% sahani.noiseRatio
% sahani.meanNoiseRatio
% keyboard
state.onlineData.sahani = sahani;

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

%% update sample spike shapes
spikeshapes = state.onlineData.spikeshapes;
%keyboard

for chan = 1:state.onlineData.nChannels
    if size(sampleWaveforms{chan}, 2)==20
        spikeshapes.shapes{chan} = sampleWaveforms{chan};
    else
        idx = randperm(20);
        idx = idx(1:size(sampleWaveforms{chan}, 2));
        spikeshapes.shapes{chan}(:, idx) = sampleWaveforms{chan};
    end
end
    
state.onlineData.spikeshapes = spikeshapes;

