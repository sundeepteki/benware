function plotData = rasterPlot(plotData,data,chan)

global fs_in;

figure(1);
for chan = 1:32
  l = length(data{chan})-plotData.index;
  if l>1000
    df = filtfilt(plotData.filter.B,plotData.filter.A,data{chan}(plotData.index:end));
    s = df / std(df(:)) + plotData.threshold;
    plotData.spiketimes{chan} = [plotData.spiketimes{chan} plotData.index+find(diff(sign(s))>0)];
  
    plot(plotData.subplotHandles(chan),plotData.spiketimes{chan}/fs_in,chan);
    plotData.index = length(data{chan});
  end
end
