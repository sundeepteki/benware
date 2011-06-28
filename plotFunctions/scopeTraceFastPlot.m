function plotData = scopeTraceFastPlot(plotData, data, dataIndex, spikeTimes)

global dataGain;

fs_in = plotData.fs_in;

nSamplesToPlot = 500;

if size(data,2)<nSamplesToPlot
  samplesToPlot = 1:size(data,2);
else
  samplesToPlot = round(linspace(1,size(data,2),nSamplesToPlot));
end

sampleTimes = samplesToPlot/fs_in;

%x = (1:100:size(data, 2))/fs_in;
for chan = 1:32
  ax = plotData.subplotHandles(chan);
  cla(ax);
  %line(x, data(chan, 1:100:end), 'parent', ax);
  line(sampleTimes,data(chan,samplesToPlot)*dataGain,'parent',ax);
end

