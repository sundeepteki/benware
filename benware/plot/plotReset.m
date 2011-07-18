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
    
    if ~isempty(newSpikes)
      h = histc(newSpikes, plotData.psthEdges);
      plotData.psth(chan).data = plotData.psth(chan).data + h(1:end-1);
    end
    
    scaled = plotData.psth(chan).data/max(plotData.psth(chan).data)*2-1;

    set(plotData.psth(chan).line,'ydata',scaled, 'color', col);

  end
  
end

plotData.firstSweep = false;