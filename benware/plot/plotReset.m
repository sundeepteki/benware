function plotData = plotReset(plotData)
% plotData = scopeTraceFastReset(plotData)
%
% Clear the axes of the graphs in the main window, if necessary

global state;

nSamplesExpected = plotData.nSamplesExpected;
fs_in = plotData.fs_in;
plotData.plotIndex = zeros(1,plotData.nChannels);

for chan = 1:plotData.nChannels
  
  % for maximum speed, we should check whether anything has been plotted on the axes in
  % question. If not, don't reset
  
  set(plotData.waveform(chan).line, 'XData', [], 'YData', []);
  set(plotData.waveform(chan).dots, 'XData', [], 'YData', []);
  
  if ~plotData.firstSweep
    if state.audioMonitor.channel==chan
      col = [1 0 0];
    else
      col = [0 0 1];
    end
    
    % update raster
    set(plotData.raster(chan).currentSweep, 'XData', [], 'YData', []);
    
    oldSpikeX = get(plotData.raster(chan).oldSweeps,'XData');
    oldSpikeY = get(plotData.raster(chan).oldSweeps,'YData');
    keep = oldSpikeY>=-0.95;
    
    newSpikes = plotData.lastSweepSpikes{chan}'/1000;
    maxSpikes = 500; %max(100, 25*nSamplesExpected/fs_in);
    if length(newSpikes)>maxSpikes
      newSpikes = newSpikes(round(linspace(1,length(newSpikes),maxSpikes)));
    end
    oldSpikeX = [newSpikes oldSpikeX(keep)];
    oldSpikeY = [ones(size(newSpikes)) oldSpikeY(keep)]-0.05;
    set(plotData.raster(chan).oldSweeps, 'XData', oldSpikeX, 'YData', oldSpikeY);
    
    % update PSTH
    % if ~isempty(newSpikes)
    %   h = histc(newSpikes, plotData.psthEdges);
    %   plotData.psth(chan).data = plotData.psth(chan).data + h(1:end-1);
    % end

    % scaling / axis label should change even when newSpikes is empty
    % oldPSTH = false;
    % if oldPSTH
    %   mx = max(plotData.psth(chan).data);
    %   scaled = plotData.psth(chan).data/mx*2-1;
    %   psthY = reshape(repmat(scaled,2,1),1,2*length(scaled));

    %   set(plotData.psth(chan).line,'ydata',psthY, 'color', col);
    %   set(plotData.psth(chan).labelHandles(2), 'string', sprintf('%d', mx));
    % else
    active_psth = [];
    switch state.plot.type
      case 'p'
        active_psth = state.onlineData.psth.pooledData;
      case cellstr(char(48:57)')' % numbers 0-9
        n = str2num(state.plot.type);
        if n>state.onlineData.nSets;
          active_psth = state.onlineData.psth.pooledData;
        else
          active_psth = state.onlineData.psth.data(:, :, str2num(state.plot.type));
        end
    end

    if ~isempty(active_psth)
      mx = max(active_psth(1:end-1, chan));
      scaled = active_psth(1:end-1, chan)/mx*2-1;
      psthY = reshape(repmat(scaled',2,1),1,2*length(scaled));

      set(plotData.psth(chan).line,'ydata',psthY, 'color', col);
      set(plotData.psth(chan).labelHandles(2), 'string', sprintf('%d', mx));
    end
    % end
  end
  
end

plotData.firstSweep = false;
