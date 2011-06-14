% test spike finder

fs_in = 24414.0625;
spikeFilter = makeSpikeFilter(fs_in);

a = load('f:/example.mat');

spikeTimes = cell(1,1);
spikeIndex = 0;

for ii = 1:length(a.b);
  data{1} = a.b(ii).signal;
  spikeTimes = appendSpikes(spikeTimes,data,spikeIndex,spikeFilter,-4);
  length(spikeTimes{1})
end

hist(spikeTimes{1},100)

%%
bins = (0:10:500)';
psth = zeros(size(bins));
for ii = 1:length(spikeTimes)
  psth = psth + histc(spikeTimes{ii},bins);
end