function plotData = rasterInit(plotData)

global fs_in;

% build filter
Wp = [300 3000];
n = 2;
[plotData.filter.B,plotData.filter.A] = ellip(n, 0.01, 40, Wp/(fs_in/2));

% remember what we've processed already
plotData.index = ones(1,32);
plotData.spiketimes = cell(1,32);

% spike threshold
plotData.threshold = 4;

figure(1);
for ii = 1:32
  plotData.subplotHandles(ii) = subplot(8,4,ii);
end