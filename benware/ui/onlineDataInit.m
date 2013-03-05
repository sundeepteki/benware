function onlineData = onlineDataInit(sampleRate, nChannels, nSamplesExpected, grid)

if strcmp(sampleRate, 'reset')
	global state;
	onlineData.nSweeps = 0;
	onlineData.nSets = state.onlineData.nSets;
	onlineData.nChannels = state.onlineData.nChannels;
	onlineData.sampleRate = state.onlineData.sampleRate;
	sampleRate = onlineData.sampleRate;
	onlineData.nSamplesExpected = state.onlineData.nSamplesExpected;

else
	onlineData.nSweeps = 0;
	onlineData.nSets = size(grid.stimGrid, 1);
	onlineData.nChannels = nChannels;
	onlineData.sampleRate = sampleRate;
	onlineData.nSamplesExpected = nSamplesExpected;
end

onlineData.nSamplesToPlot = 2000;

% cell array containing spike times from the last sweeps on each channel
%onlineData.spikeTimes = cell(o1, onlineData.nChannels);

% PSTH
possible_binsizes = [1 2.5 5 10 25 50 100 250 1000 2500 5000 10000]/1000; % sec
binsize = possible_binsizes( ...
        find(onlineData.nSamplesExpected/onlineData.sampleRate/50>possible_binsizes, 1, 'last'));
if isempty(binsize)
    binsize = min(possible_binsizes);
end

onlineData.psth.binsize = binsize;
edges = 0:onlineData.psth.binsize:onlineData.nSamplesExpected/onlineData.sampleRate;
onlineData.psth.edges = edges(1:end-1);
onlineData.psth.nBins = length(onlineData.psth.edges);
onlineData.psth.centres = (onlineData.psth.edges(1:end-1)+onlineData.psth.edges(2:end))/2;
onlineData.psth.data = zeros(onlineData.psth.nBins, onlineData.nChannels, onlineData.nSets);
onlineData.psth.nSweeps = zeros(1, onlineData.nSets);
onlineData.psth.pooledData = zeros(onlineData.psth.nBins, onlineData.nChannels);
onlineData.psth.nPooledSweeps = 0;

% LFP, downsampled to a maximum of nSamplesToPlot samples (or 1000Hz)
onlineData.lfp.sampleRate = 1000; % Hz
nLFPsamplesExpected = onlineData.nSamplesExpected/sampleRate * onlineData.lfp.sampleRate;

if nLFPsamplesExpected<onlineData.nSamplesToPlot
    onlineData.samplesToPlot = 1:nLFPsamplesExpected;
else
    onlineData.samplesToPlot = round(linspace(1,nLFPSamplesExpected,onlineData.nSamplesToPlot));
end
