function spikeFilter = makeSpikeFilter(fs)
% spikeFilter = makeSpikeFilter(fs)
%
% Makes a filter appropriate for filtering waveforms for spike detection
% 
% fs: Sampling frequency
% 
% The deadTime output is just a guess at how many samples are invalid
% when this filter is used to filter a signal.

Wp = [300 3000];
n = 2;
[spikeFilter.B,spikeFilter.A] = ellip(n, 0.01, 40, Wp/(fs/2));

% arbitrary
spikeFilter.deadTime = 50;
