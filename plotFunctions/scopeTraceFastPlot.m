function plotData = scopeTraceFastPlot(plotData, data, dataIndex, filteredData, fDataIndex, spikeTimes, spikeTimesNew)
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
  
  if state.plot.waveform
    
    toPlot = plotData.samplesToPlot < ii(chan);
    
    set(plotData.lineHandles(chan), 'XData', plotData.sampleTimes(toPlot), 'YData', d(chan, plotData.samplesToPlot(toPlot)) * state.dataGain, 'color', col, 'visible', 'on');
  end
  
  if state.plot.raster
    t_s = spikeTimes{chan}'/1000;
    set(plotData.rasterHandles(chan), 'XData', t_s, 'YData', 0.75*ones(size(t_s)), 'markeredgecolor', col, 'visible', 'on');
    
    %t_s = spikeTimesNew{chan}(1:min(500,length(spikeTimesNew{chan})))'/1000;
    %t_s = t_s(t_s>plotData.plotIndex(chan)/fs_in)';
    %line(t_s,.75*ones(size(t_s)),'marker','.','linestyle','none', 'parent', plotData.subplotHandles(chan),'hittest','off','markeredgecolor',col);
    %if ~isempty(spikeTimesNew{1})
    %  keyboard;
    %end
    
  end
  
  plotData.plotIndex(chan) = ii(chan);
  
end
