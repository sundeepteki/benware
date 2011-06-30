function plotData = scopeTraceFastPlot(plotData, data, dataIndex, filteredData, fDataIndex, spikeTimes)

global state;

if ~state.plot.enabled
  return;
end

fs_in = plotData.fs_in;

if state.plot.filtered
  d = filteredData;
  ii = fDataIndex;
else
  d = data;
  ii = dataIndex;
end

for chan = 1:32
  
  if state.plot.onlyActiveChannel && chan~=state.audioMonitor.channel
    continue
  end
  
  plotData.clean(chan) = false;
  
  if state.audioMonitor.channel==chan
    col = [1 0 0];
  else
    col = [0 0 1];
  end
  toPlot = (plotData.samplesToPlot >= plotData.plotIndex(chan)) & (plotData.samplesToPlot < ii(chan));
  line(plotData.sampleTimes(toPlot), d(chan, plotData.samplesToPlot(toPlot)) * state.dataGain, 'color', col, 'parent', plotData.subplotHandles(chan),'hittest','off');

  
  if state.plot.raster
    t_s = spikeTimes{chan}/1000;
    t_s = t_s(t_s>plotData.plotIndex(chan)/fs_in)';
    line(t_s,.9*ones(size(t_s)),'marker','.','linestyle','none', 'parent', plotData.subplotHandles(chan),'hittest','off');
  end
  
  plotData.plotIndex(chan) = d(chan);
end

