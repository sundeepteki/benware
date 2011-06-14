function plotData = scopeTraceWithSpikesPlot(plotData,data,spikeTimes)

global fs_in;

figure(1);
for chan = 1:32
  plot(plotData.subplotHandles(chan),(1:100:length(data{chan}))/fs_in,data{chan}(1:100:end));
  if ~isempty(spikeTimes{chan}) && length(spikeTimes{chan})<1000
    hold(plotData.subplotHandles(chan),'on');
    %keyboard
    plot(plotData.subplotHandles(chan),spikeTimes{chan}/1000,0,'k+');
    hold(plotData.subplotHandles(chan),'off');
  end
end