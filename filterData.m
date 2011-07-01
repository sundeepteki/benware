function [data, offset] = filterData(data, spikeFilter)
% data = filterSignal(signal, spikeFilter)
% 
% Filters a mxn signal, if the signal is long enough, chopping
% off the invalid parts at the ends.
% If the signal is empty, return an empty signal without doing anything.
% 
% signal: A 1xn signal
% spikeFilter.B, spikeFilter.A: the filter
% spikeFilter.deadTime: the number of samples to chop off both ends

% check the signal is long enough to provide a meaningful output

if size(data, 2) < (2*spikeFilter.deadTime + 3)
    data = zeros(32,0);
    return
end

% leave empty signals unchanged
% (note that any() is fast -- it returns as soon as it finds something)
validChans = any(data, 2);

% replace valid channels with filtered versions
if length(validChans) > 0
  filtData(validChans,:) = filtfilt(spikeFilter.B, spikeFilter.A, data(validChans,:)')';
end

% chop off the invalid ends of the filtered signals
signal = signal(spikeFilter.deadTime:end-spikeFilter.deadTime);

offset = spikeFilter.deadTime;