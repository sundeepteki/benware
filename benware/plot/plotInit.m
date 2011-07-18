function plotData = plotInit(fs_in, nChannels, nSamplesExpected)
% plotData = scopeTraceFastInit(plotData, fs_in, nSamplesExpected)
%
% Initialise main figure window. This is run once per grid, at the start

global state

plotData = struct;
plotData.fs_in = fs_in;
plotData.nSamplesExpected = nSamplesExpected;
plotData.nChannels = nChannels;

plotData.nSamplesToPlot = 2000;

if plotData.nSamplesExpected<plotData.nSamplesToPlot
    plotData.samplesToPlot = 1:plotData.nSamplesExpected;
else
    plotData.samplesToPlot = round(linspace(1,nSamplesExpected,plotData.nSamplesToPlot));
end

plotData.sampleTimes = plotData.samplesToPlot/fs_in;

plotData.lineHandles = zeros(1,plotData.nChannels)-1;

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
set(f,'color',[1 1 1], 'renderer', 'opengl', 'KeyPressFcn',{'keyPress'}, ...
  'name', 'BenWare', 'numbertitle', 'off', 'toolbar', 'none', 'menubar', 'none');
clf;

nSamplesExpected = plotData.nSamplesExpected;
fs_in = plotData.fs_in;
plotData.plotIndex = zeros(1,plotData.nChannels);

plotData.psthEdges = linspace(0,plotData.nSamplesExpected/fs_in,50);
psthX = reshape(repmat(plotData.psthEdges,2,1),1,2*length(plotData.psthEdges));
plotData.psthX = psthX(2:end-1);
plotData.psthCentres = (plotData.psthEdges(1:end-1)+plotData.psthEdges(2:end))/2;

% on Mac, need to set the y axis slightly right of the minimum possible value
% for it to actually be seen. Similarly for a axis
if ispc
  minX = 1/fs_in;
  minY = -1;
else
  minX = 1.25/fs_in;
  minY = -1+1e-4;
end

for chan = 1:plotData.nChannels
    ax =  axes('position', pos{chan}, 'xtick', [], 'ytick', [], ...
        'xlim', [1 nSamplesExpected]/fs_in, 'ylim', [-1 1], ...
        'drawmode', 'fast', 'ticklength', [0 0], ...
        'xcolor', get(f,'color'), 'ycolor', get(f,'color'),  'ButtonDownFcn', {'clickOnSubplot',chan});
    
    plotData.subplot(chan) = ax;
    
    plotData.waveform(chan).axis.x = line([1 nSamplesExpected]/fs_in, [0 0], ...
        'color', [0 0 0], 'parent', plotData.subplot(chan),'hittest','off');
    plotData.waveform(chan).axis.y = line([minX minX], [-1 1], ...
        'color', [0 0 0],'parent',plotData.subplot(chan),'hittest','off');
    plotData.waveform(chan).line = line(0, 0, 'parent', plotData.subplot(chan),'hittest','off', 'visible', 'off');
    plotData.waveform(chan).dots = line(0, 0, 'marker', '.', 'linestyle', 'none', 'parent', plotData.subplot(chan),'hittest','off', 'visible', 'off');
    plotData.waveform(chan).handles = [plotData.waveform(chan).axis.x plotData.waveform(chan).axis.y plotData.waveform(chan).line plotData.waveform(chan).dots];
    plotData.waveform(chan).dataHandles = [plotData.waveform(chan).line plotData.waveform(chan).dots];
    
    plotData.raster(chan).axis.x = line([1 nSamplesExpected]/fs_in, [minY minY], ...
        'color', [0 0 0], 'parent', plotData.subplot(chan),'hittest','off', 'visible', 'off');
    plotData.raster(chan).axis.y = line([minX minX], [-1 1], ...
        'color', [0 0 0],'parent',plotData.subplot(chan),'hittest','off', 'visible', 'off');
    plotData.raster(chan).currentSweep = line(0, 0, 'marker', '.', 'linestyle', 'none', 'parent', plotData.subplot(chan),'hittest','off', 'visible', 'off');
    plotData.raster(chan).oldSweeps = line(0, 0, 'marker', '.', 'linestyle', 'none', 'parent', plotData.subplot(chan),'hittest','off', 'visible', 'off');
    set(plotData.raster(chan).oldSweeps, 'XData', [], 'YData', []);
    plotData.raster(chan).handles = [plotData.raster(chan).axis.x plotData.raster(chan).axis.y ...
        plotData.raster(chan).currentSweep plotData.raster(chan).oldSweeps];
    plotData.raster(chan).dataHandles = [plotData.raster(chan).currentSweep plotData.raster(chan).oldSweeps];

    plotData.psth(chan).data = zeros(size(plotData.psthCentres));
    psthY = reshape(repmat(plotData.psth(chan).data,2,1),1,2*length(plotData.psth(chan).data));
    plotData.psth(chan).axis.x = line([1 nSamplesExpected]/fs_in, [minY minY], ...
        'color', [0 0 0], 'parent', plotData.subplot(chan),'hittest','off', 'visible', 'off');
    plotData.psth(chan).axis.y = line([minX minX], [-1 1], ...
        'color', [0 0 0],'parent',plotData.subplot(chan),'hittest','off', 'visible', 'off');
    plotData.psth(chan).line = line(plotData.psthX, psthY, 'parent', plotData.subplot(chan),'hittest','off', 'visible', 'off');
    plotData.psth(chan).handles = [plotData.psth(chan).axis.x plotData.psth(chan).axis.y plotData.psth(chan).line];
    plotData.psth(chan).dataHandles = [plotData.psth(chan).line];
    
    plotData.activeHandles{chan} = plotData.waveform(chan).handles;
end

state.plot.typeShouldChange = true;
state.plot.activeChannelShouldChange = true;
state.plot.shouldDisable = false;
plotData.firstSweep = true;
plotData.lastDrawTime = 0;
plotData.nSweeps = 0;



