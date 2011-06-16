function plotData = scopeTraceSpikesPlot(plotData, data, index, spikeTimes)

global fs_in dataGain;

% plot 2000 equally spaced samples, or the whole signal, whichever is shorter
nSamplesToPlot = 2000;

if size(data,2)<nSamplesToPlot
  samplesToPlot = 1:size(data,2);
else
  samplesToPlot = round(linspace(1,size(data,2),nSamplesToPlot));
  sampleTimes = samplesToPlot/fs_in;
end


for chan = 1:32
  ax = plotData.subplotHandles(chan);
  cla(ax);  
  line(sampleTimes,data(chan,samplesToPlot),'parent',ax);
  
  % also mark the times of up to 500 spikes
  l = length(spikeTimes{chan});
  if l<500
    spikesToPlot = 1:l;
  else
    spikesToPlot = round(linspace(1,l,500));
  end

  %get(ax,'ylim')
  %length(spikesToPlot)
  h = line(spikeTimes{chan}(spikesToPlot)/1000,0.9*dataGain*ones(size(spikesToPlot)), 'parent',ax);
  set(h,'LineStyle','None','Marker','.');
  
end

