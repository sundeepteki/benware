function signal = filterSignal(signal, spikeFilter)

if length(signal) < (2*spikeFilter.deadTime + 3)
    signal = [];
    return
end

if any(signal)
  signal = filtfilt(spikeFilter.B, spikeFilter.A, signal);
end

signal = signal(deadtime:end-deadtime);
