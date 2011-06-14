function plotData = scopeTracePlot(plotData,data,spikeTimes)

global fs_in;

figure(1);
len = size(data,2);
for chan = 1:32
  plot(plotData.subplotHandles(chan),(1:100:len)/fs_in,data(chan,1:100:end));
end