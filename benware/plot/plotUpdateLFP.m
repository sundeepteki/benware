function plotData = plotUpdateLFP(plotData, data)
% update running average plots

nSweeps = plotData.nSweeps;

newLFP = nan(plotData.nChannels, length(plotData.samplesToPlot));

for chan = 1:plotData.nChannels
    if nSweeps==1
	   	newLFP(chan,:) = data(chan, plotData.samplesToPlot);
    else
    	oldLFPSum = get(plotData.lfp(chan).line,'ydata')/plotData.lfpGain*(nSweeps-1);
    	newLFP(chan,:) = (oldLFPSum+data(chan, plotData.samplesToPlot))/nSweeps;
    end
end

plotData.lfpGain = 0.8/max(abs(newLFP(:)));

for chan = 1:plotData.nChannels
  	set(plotData.lfp(chan).line,'ydata',newLFP(chan,:)*plotData.lfpGain);
end
