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
  ii = fDataIndex;
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

% switch the active handles to the currently selected plot type
if state.plot.typeShouldChange
  for chan = 1:plotData.nChannels
    makeInvisible(plotData.activeHandles{chan});
    switch state.plot.type
      case 'w'
        % waveform
        plotData.activeHandles{chan} = plotData.waveform(chan).handles;
        plotData.dataHandles{chan} = plotData.waveform(chan).dataHandles;

      case 'r'
        % raster
        plotData.activeHandles{chan} = plotData.raster(chan).handles;
        plotData.dataHandles{chan} = plotData.raster(chan).dataHandles;

      case 'p'
        % set data to the pooled PSTH; copied from plotReset
        plotData.activeHandles{chan} = plotData.psth(chan).handles;
        plotData.dataHandles{chan} = plotData.psth(chan).dataHandles;
        active_psth = state.onlineData.psth.pooledData;
        mx = max(active_psth(1:end-1, chan))*1.05;
        scaled = active_psth(1:end-1, chan)/mx*2-1;
        psthY = reshape(repmat(scaled',2,1),1,2*length(scaled));
        set(plotData.psth(chan).line,'ydata',psthY);
        set(plotData.psth(chan).labelHandles(2), 'string', sprintf('%d', mx));

      case cellstr(char(49:57)')' % numbers 1-9
        % set data to the appropriate per-set PSTH; copied from plotReset
        plotData.activeHandles{chan} = plotData.psth(chan).handles;
        plotData.dataHandles{chan} = plotData.psth(chan).dataHandles;
        n = str2num(state.plot.type);
        if n>state.onlineData.nSets;
          active_psth = state.onlineData.psth.pooledData;
        else
          active_psth = state.onlineData.psth.data(:, :, str2num(state.plot.type));
        end
        mx = max(active_psth(1:end-1, chan));
        scaled = active_psth(1:end-1, chan)/mx*2-1;
        psthY = reshape(repmat(scaled',2,1),1,2*length(scaled));
        set(plotData.psth(chan).line,'ydata',psthY);
        set(plotData.psth(chan).labelHandles(2), 'string', sprintf('%d', mx));

      case 'l'
        % LFP
        plotData.activeHandles{chan} = plotData.lfp(chan).handles;
        plotData.dataHandles{chan} = plotData.lfp(chan).dataHandles;

      case 's'
        % spike shapes
        plotData.activeHandles{chan} = plotData.spikes(chan).handles;
        plotData.dataHandles{chan} = plotData.spikes(chan).dataHandles;

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

% now, update the data for those plot types that change during a sweep
% for other plots, just set the line colour to show the active channel
for chan = plotChans
    
  if state.audioMonitor.channel==chan
    col = [1 0 0];
  else
    col = [0 0 1];
  end
  
  switch state.plot.type
    case 'w'
      toPlot = plotData.samplesToPlot < ii;
      set(plotData.waveform(chan).line, 'XData', plotData.sampleTimes(toPlot), 'YData', d(chan, plotData.samplesToPlot(toPlot)) * gain, 'color', col);
      t_s = spikeTimes{chan}'/1000;
      maxSpikes = 500*ii/plotData.nSamplesExpected;
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
      % get all spike times for this sweep, but plot only a subset if there are too many
      % in plotReset, the current sweep will be made old
      t_s = spikeTimes{chan}'/1000;
      maxSpikes = 500*ii/plotData.nSamplesExpected; %max(100, 25*plotData.nSamplesExpected/plotData.fs_in);
      if length(t_s)>maxSpikes
        t_s = t_s(round(linspace(1,length(t_s),maxSpikes)));
      end
      set(plotData.raster(chan).currentSweep, 'XData', t_s, 'YData', ones(size(t_s)), 'markeredgecolor', col);
      set(plotData.raster(chan).oldSweeps, 'markeredgecolor', col);
      
    case 'p'
      % nothing to do (plot is updated in plotReset)
      % Just set color appropriately
      set(plotData.psth(chan).line, 'color', col);

    case cellstr(char(49:57)')' % numbers 1-9
      % nothing to do (plot is updated in plotReset)
      % Just set color appropriately
      set(plotData.psth(chan).line, 'color', col);

    case 'l'
      % nothing to do (plot is updated in plotReset)
      % Just set color appropriately
      set(plotData.lfp(chan).line, 'color', col);

    case 's'
      % nothing to do (plot is updated in plotReset)
      % Just set color appropriately
      set(plotData.lfp(chan).line, 'color', col);

  end
  
  plotData.plotIndex(chan) = ii;
  
end

drawnow;
