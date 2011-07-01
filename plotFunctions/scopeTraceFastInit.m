function plotData = scopeTraceFastInit(plotData, fs_in, nSamplesExpected)
% plotData = scopeTraceFastInit(plotData, fs_in, nSamplesExpected)
%
% Initialise main figure window. This is run once per grid, at the start

plotData.fs_in = fs_in;
plotData.nSamplesExpected = nSamplesExpected;

plotData.nSamplesToPlot = 2000;

if plotData.nSamplesExpected<plotData.nSamplesToPlot
  plotData.samplesToPlot = 1:plotData.nSamplesExpected;
else
  plotData.samplesToPlot = round(linspace(1,nSamplesExpected,plotData.nSamplesToPlot));
end

plotData.sampleTimes = plotData.samplesToPlot/fs_in;

plotData.lineHandles = zeros(1,32)-1;

% positions
n.rows = 8;
n.cols = 4;

w = struct;
w.L = 0.025;
w.R = 0.025;
w.gap = 0.025;
w.allGaps = w.gap * (n.cols - 1);
w.allPlots = 1 - w.L - w.R - w.allGaps;
w.plot = w.allPlots / n.cols;

h = struct;
h.T = 0.025;
h.B = 0.025;
h.gap = 0.025;
h.allGaps = h.gap * (n.rows - 1);
h.allPlots = 1 - h.T - h.B - h.allGaps;
h.plot = h.allPlots / n.rows;

xi = struct;
xi.col(1) = w.L;
for ii=2:n.cols
  xi.col(ii) = xi.col(ii-1) + w.plot + w.gap;
end

yi = struct;
yi.row(n.rows) = h.B;
for ii=(n.rows-1):-1:1
  yi.row(ii) = yi.row(ii+1) + h.plot + h.gap;
end

pos = cell(n.rows, n.cols);
for ii=1:n.rows
  for jj=1:n.cols
    pos{ii, jj} = [xi.col(jj) yi.row(ii) w.plot h.plot];
  end
end
pos = pos';
  
% create figure
f = figure(1);
set(f,'color',[1 1 1], 'renderer', 'opengl', 'KeyPressFcn',{'keyPress'});
clf;
for ii = 1:32
  plotData.subplotHandles(ii) = axes('position', pos{ii}, 'xtick', [], 'ytick', [], ...
    'xlim', [1 nSamplesExpected]/fs_in, 'ylim', [-1 1], 'drawmode', 'fast', ...
    'xcolor',get(f,'color'), 'ButtonDownFcn', {'clickOnSubplot',ii});
end

% the axis lines haven't yet been drawn, so mark the plots dirty so that
% scopeTraceFastPlot will know that it has to drawn them
plotData.clean = false(1,32);
