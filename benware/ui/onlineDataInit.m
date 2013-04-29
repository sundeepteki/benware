function onlineData = onlineDataInit(sampleRate, nChannels, nSamplesExpected, grid)

if strcmp(sampleRate, 'reset')
	global state;
	onlineData.nSets = state.onlineData.nSets;
	onlineData.nChannels = state.onlineData.nChannels;
	onlineData.sampleRate = state.onlineData.sampleRate;
	sampleRate = onlineData.sampleRate;
	onlineData.nSamplesExpected = state.onlineData.nSamplesExpected;

else
	onlineData.nSets = size(grid.stimGrid, 1);
	onlineData.nChannels = nChannels;
	onlineData.sampleRate = sampleRate;
	onlineData.nSamplesExpected = nSamplesExpected;

end

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

% PSTH for Sahani noise power
onlineData.sahani.binsize = 25/1000; % 5 ms bins
maxbin = min(onlineData.nSamplesExpected/onlineData.sampleRate, 1); % up to 1 second of data
edges = 0:onlineData.sahani.binsize:maxbin;
onlineData.sahani.edges = edges(1:end-1);
onlineData.sahani.nBins = length(onlineData.sahani.edges);
onlineData.sahani.centres = (onlineData.sahani.edges(1:end-1)+onlineData.sahani.edges(2:end))/2;
onlineData.sahani.data = cell(onlineData.nChannels, onlineData.nSets);
onlineData.sahani.nSweeps = zeros(1, onlineData.nSets);
onlineData.sahani.noiseRatio = nan(onlineData.nChannels, onlineData.nSets);
onlineData.sahani.meanNoiseRatio = nan(1, onlineData.nChannels);

% LFP, downsampled to a maximum of nSamplesToPlot samples (or 1000Hz)
onlineData.lfp.sampleRate = 1000; % Hz
onlineData.lfp.nSamplesToKeep = 2000;
onlineData.lfp.nSweeps = 0;

nLFPsamplesExpected = onlineData.nSamplesExpected/sampleRate * onlineData.lfp.sampleRate;
onlineData.lfp.sampleTimes = (0:round(nLFPsamplesExpected)-1)*1/onlineData.lfp.sampleRate;

if nLFPsamplesExpected<onlineData.lfp.nSamplesToKeep
    onlineData.lfp.samplesToKeep = 1:nLFPsamplesExpected;
else
    onlineData.lfp.samplesToKeep = round(linspace(1,nLFPsamplesExpected,onlineData.lfp.nSamplesToKeep));
end
onlineData.lfp.keptSampleTimes = onlineData.lfp.sampleTimes(onlineData.lfp.samplesToKeep);
onlineData.lfp.sum = nan(onlineData.nChannels, length(onlineData.lfp.samplesToKeep));

% spike shapes
onlineData.spikeshapes.nSpikeShapes = 100;
onlineData.spikeshapes.nSamples = floor(sampleRate/1000);
onlineData.spikeshapes.shapes = cell(1, onlineData.nChannels);
for chan = 1:onlineData.nChannels
   onlineData.spikeshapes.shapes{chan} = ...
       zeros(onlineData.spikeshapes.nSamples, onlineData.spikeshapes.nSpikeShapes); 
end

