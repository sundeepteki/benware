function plotData = scopeTraceFastReset(plotData)

nSamplesExpected = plotData.nSamplesExpected;
fs_in = plotData.fs_in;
plotData.plotIndex = zeros(1,32);

if plotData.clean
  return;
end

for chan = 1:32
  
  if plotData.clean(chan)
    continue
  end
  
  ax = plotData.subplotHandles(chan);
  cla(ax);
  line([1 nSamplesExpected]/fs_in, [0 0], 'color', [0 0 0], 'parent', plotData.subplotHandles(chan),'hittest','off');
  line([1 1]/fs_in, [-1 1], 'color', [0 0 0],'parent',plotData.subplotHandles(chan),'hittest','off');
  
  plotData.clean(chan) = true;

end

