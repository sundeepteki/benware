function signal = filterSignal(signal, spikeFilter)
% signal = filterSignal(signal, spikeFilter)
% 
% Filters a 1xn signal, if the signal is long enough, chopping
% off the invalid parts at the ends.
% If the signal is empty, return an empty signal without doing anything.
% 
% signal: A 1xn signal
% spikeFilter.B, spikeFilter.A: the filter
% spikeFilter.deadTime: the number of samples to chop off both ends

% check the signal is long enough to provide a meaningful output
if length(signal) < (2*spikeFilter.deadTime + 3)
    signal = [];
    return
end

% don't do anything if the signal is empty
% (note that any() is fast -- it returns as soon as it finds something)
if any(signal)
  signal = filtfilt(spikeFilter.B, spikeFilter.A, signal);
end

% filter
signal = signal(spikeFilter.deadTime:end-spikeFilter.deadTime);
