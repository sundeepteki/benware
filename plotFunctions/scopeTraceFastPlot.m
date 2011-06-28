function plotData = scopeTraceFastPlot(plotData, data, dataIndex, spikeTimes)

global state;

if ~state.plot.enabled
  return;
end

plotData.clean = false;

fs_in = plotData.fs_in;

for chan = 1:32
  if state.audioMonitor.channel==chan
    col = [1 0 0];
  else
    col = [0 0 1];
  end
  toPlot = (plotData.samplesToPlot >= plotData.plotIndex(chan)) & (plotData.samplesToPlot < dataIndex(chan));
  line(plotData.sampleTimes(toPlot), data(chan,plotData.samplesToPlot(toPlot))*state.dataGain, 'color', col, 'parent', plotData.subplotHandles(chan),'hittest','off');
  plotData.plotIndex(chan) = dataIndex(chan);
end

