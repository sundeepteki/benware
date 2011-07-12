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
  ii = repmat(fDataIndex,1,32);
  gain = state.dataGainFiltered;
else
  d = data;
  ii = dataIndex;
  gain = state.dataGainRaw;
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
  
  if state.plot.waveform
    toPlot = plotData.samplesToPlot < ii(chan);
    set(plotData.lineHandles(chan), 'XData', plotData.sampleTimes(toPlot), 'YData', d(chan, plotData.samplesToPlot(toPlot)) * gain, 'color', col, 'visible', 'on');
  
    t_s = spikeTimes{chan}'/1000;
    set(plotData.rasterHandles(chan), 'XData', t_s, 'YData', 0.75*ones(size(t_s)), 'markeredgecolor', col, 'visible', 'on');
    
  elseif state.plot.raster
      
  end
  
  plotData.plotIndex(chan) = ii(chan);
  
end
