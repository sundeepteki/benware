function plotData = scopeTraceFastPlot(plotData, data, spikeTimes)

global fs_in;

x = (1:100:size(data, 2))/fs_in;
for chan = 1:32
  ax = plotData.subplotHandles(chan);
  cla(ax);
  line(x, data(chan, 1:100:end), 'parent', ax);
end

