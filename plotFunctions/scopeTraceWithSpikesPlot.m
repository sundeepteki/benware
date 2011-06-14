function plotData = scopeTraceWithSpikesPlot(plotData,data,spikeTimes)

global fs_in;

figure(1);
for chan = 1:32
  plot(plotData.subplotHandles(chan),(1:100:size(data,2))/fs_in,data(chan,1:100:end),'k');
  if ~isempty(spikeTimes{chan}) && length(spikeTimes{chan})<100
    hold(plotData.subplotHandles(chan),'on');
    plot(plotData.subplotHandles(chan),spikeTimes{chan}/1000,0,'r+','MarkerSize',14);
    hold(plotData.subplotHandles(chan),'off');
  end
end