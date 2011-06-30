function plotData = scopeTraceFastPlot(plotData, data, dataIndex, filteredData, fDataIndex, spikeTimes)
% plotData = scopeTraceFastPlot(plotData, data, dataIndex, filteredData, fDataIndex, spikeTimesOld, spikeTimes)
% 
% Update the plots in the main window. Run numerous times per sweep

global state;

% if plotting is switched off, do nothing
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
  
  % record the fact that we've plotted on the axes (so they'll eventually
  % need to be cleared by scopeTraceFastReset)
  plotData.clean(chan) = false;
  
  if state.audioMonitor.channel==chan
    col = [1 0 0];
  else
    col = [0 0 1];
  end
  toPlot = (plotData.samplesToPlot >= plotData.plotIndex(chan)) & (plotData.samplesToPlot < ii(chan));
  line(plotData.sampleTimes(toPlot), d(chan, plotData.samplesToPlot(toPlot)) * state.dataGain, 'color', col, 'parent', plotData.subplotHandles(chan),'hittest','off');

  
  if state.plot.raster
    if length(spikeTimes{chan})<50
      t_s = spikeTimes{chan}'/1000;
      t_s = t_s(t_s>plotData.plotIndex(chan)/fs_in)';
      line(t_s,.5*ones(size(t_s)),'marker','.','linestyle','none', 'parent', plotData.subplotHandles(chan),'hittest','off','markeredgecolor',col);
    end
  end
  
  plotData.plotIndex(chan) = d(chan);
end

