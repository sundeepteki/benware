function plotData = scopeTraceInit(plotData)

figure(1);
for ii = 1:32
  plotData.subplotHandles(ii) = subplot(8,4,ii);
end