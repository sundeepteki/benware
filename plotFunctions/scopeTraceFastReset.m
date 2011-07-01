function plotData = scopeTraceFastReset(plotData)
% plotData = scopeTraceFastReset(plotData)
% 
% Clear the axes of the graphs in the main window, if necessary

nSamplesExpected = plotData.nSamplesExpected;
fs_in = plotData.fs_in;
plotData.plotIndex = zeros(1,32);

for chan = 1:32
  
  % for maximum speed, check whether anything has been plotted on the axes in
  % question. If not, don't reset
  
  if plotData.clean(chan)
    continue
  end
  
  % otherwise, clear the axes and draw some axis lines
  
  ax = plotData.subplotHandles(chan);
  cla(ax);
  line([1 nSamplesExpected]/fs_in, [0 0], 'color', [0 0 0], 'parent', plotData.subplotHandles(chan),'hittest','off');
  line([1 1]/fs_in, [-1 1], 'color', [0 0 0],'parent',plotData.subplotHandles(chan),'hittest','off');
  
  plotData.lineHandles(chan) = line(0, 0, 'parent', plotData.subplotHandles(chan),'hittest','off', 'visible', 'off');
  plotData.rasterHandles(chan) = line(0, 0, 'marker', '.', 'linestyle', 'none', 'parent', plotData.subplotHandles(chan),'hittest','off', 'visible', 'off');
  
  plotData.clean(chan) = true;

end

