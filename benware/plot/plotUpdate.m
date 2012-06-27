function plotData = plotUpdate(plotData, data, dataIndex, filteredData, fDataIndex, spikeTimes)
% plotData = scopeTraceFastPlot(plotData, data, dataIndex, filteredData, fDataIndex, spikeTimesOld, spikeTimes)
%
% Update the plots in the main window. Run numerous times per sweep

global state;

% if plotting is switched off, do nothing
if state.plot.shouldDisable
  for chan = 1:plotData.nChannels
    makeInvisible(plotData.activeHandles{chan});
  end
  state.plot.shouldDisable = false;
  drawnow;
end

if ~state.plot.enabled
  n = now;
  if n-plotData.lastDrawTime>1e-5
    plotData.lastDrawTime = n;
    drawnow;
  end
  return;
end

fs_in = plotData.fs_in;

if state.plot.filtered
  d = filteredData;
  ii = repmat(fDataIndex,1,plotData.nChannels);
  gain = state.dataGainFiltered;
else
  d = data;
  ii = dataIndex;
  gain = state.dataGainRaw;
end

if state.plot.onlyActiveChannel
  plotChans = state.audioMonitor.channel;
else
  plotChans = 1:plotData.nChannels;
end

if state.plot.typeShouldChange
  for chan = 1:plotData.nChannels
    makeInvisible(plotData.activeHandles{chan});
    switch state.plot.type
      case 'w'
        plotData.activeHandles{chan} = plotData.waveform(chan).handles;
        plotData.dataHandles{chan} = plotData.waveform(chan).dataHandles;
      case 'r'
        plotData.activeHandles{chan} = plotData.raster(chan).handles;
        plotData.dataHandles{chan} = plotData.raster(chan).dataHandles;
      case 'p'
        plotData.activeHandles{chan} = plotData.psth(chan).handles;
        plotData.dataHandles{chan} = plotData.psth(chan).dataHandles;
    end
    makeVisible(plotData.activeHandles{chan});
  end
end

if state.plot.activeChannelShouldChange
  if state.plot.onlyActiveChannel
    for chan = 1:plotData.nChannels
      makeInvisible(plotData.dataHandles{chan});
    end
    makeVisible(plotData.activeHandles{state.audioMonitor.channel});
  else
    for chan = 1:plotData.nChannels
      makeVisible(plotData.activeHandles{chan});
    end
  end
end

for chan = plotChans
    
  if state.audioMonitor.channel==chan
    col = [1 0 0];
  else
    col = [0 0 1];
  end
  
  switch state.plot.type
    case 'w'
      toPlot = plotData.samplesToPlot < ii(chan);
      set(plotData.waveform(chan).line, 'XData', plotData.sampleTimes(toPlot), 'YData', d(chan, plotData.samplesToPlot(toPlot)) * gain, 'color', col);
      
      t_s = spikeTimes{chan}'/1000;
      maxSpikes = 500*ii(chan)/plotData.nSamplesExpected;
      %max(100, 25*plotData.nSamplesExpected/plotData.fs_in);
      if length(t_s)>maxSpikes
        t_s = t_s(round(linspace(1,length(t_s),maxSpikes)));
      end
      set(plotData.waveform(chan).dots, 'XData', t_s, 'YData', ones(size(t_s)), 'markeredgecolor', col);
      
      if state.plot.currentGain~=gain
        set(plotData.ylabels.waveform.handles(1), 'string', sprintf('%0.2f', -1/gain*1000));
        set(plotData.ylabels.waveform.handles(2), 'string', sprintf('%0.2f', 1/gain*1000));
        state.plot.currentGain = gain;
      end

    case 'r'
      t_s = spikeTimes{chan}'/1000;
      maxSpikes = 500*ii(chan)/plotData.nSamplesExpected; %max(100, 25*plotData.nSamplesExpected/plotData.fs_in);
      if length(t_s)>maxSpikes
        t_s = t_s(round(linspace(1,length(t_s),maxSpikes)));
      end
      set(plotData.raster(chan).currentSweep, 'XData', t_s, 'YData', ones(size(t_s)), 'markeredgecolor', col);
      set(plotData.raster(chan).oldSweeps, 'markeredgecolor', col);
      
    case 'p'
      set(plotData.psth(chan).line, 'color', col);

  end
  
  plotData.plotIndex(chan) = ii(chan);
  
end

drawnow;
