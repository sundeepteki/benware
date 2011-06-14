function spikeTimes = findSpikesFast(data,spikeFilter,fs,threshold,deadTime)

sig = filtfilt(spikeFilter.B,spikeFilter.A,data);

spikeTimes = cell(1,size(data,2));
for chan = 1:size(data,2)
  sig(:,chan) = sig(:,chan) / std(sig(:,chan)) - threshold;
  spikeTimes{chan} = (find(diff(sign(sig(deadTime:end-deadTime,chan))))+deadTime-1)/fs*1000;
end
