function spikeTimes = findSpikesFast(data,spikeFilter,fs,threshold)

sig = filtfilt(spikeFilter.B,spikeFilter.A,data);

spikeTimes = cell(1,size(data,2));
for chan = 1:size(data,2)
  sig(:,chan) = sig(:,chan) / std(sig(:,chan)) - threshold;
  spikeTimes{chan} = (find(diff(sign(sig(15:end-15,chan))))+14)/fs*1000;
end