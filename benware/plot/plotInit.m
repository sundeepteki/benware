function plotData = plotInit(fs_in, nChannels, nSamplesExpected, grid)
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
n.cols = 4;
n.rows = ceil(nChannels/n.cols);

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
%pos = pos';

% create figure
f = figure(101);
set(f,'color',[1 1 1], 'renderer', 'opengl', 'KeyPressFcn',{'keyPress'}, ...
  'name', 'BenWare', 'numbertitle', 'off', 'toolbar', 'none', 'menubar', 'none');
clf;

nSamplesExpected = plotData.nSamplesExpected;
fs_in = plotData.fs_in;
plotData.plotIndex = zeros(1,plotData.nChannels);

% PSTH x-data (repmat gives you square bars)
psthX = reshape(repmat(state.onlineData.psth.edges,2,1),1,2*length(state.onlineData.psth.edges));
plotData.psthX = psthX(2:end-1);

% on Mac, need to set the y axis slightly right of the minimum possible value
% for it to actually be seen. Similarly for a axis
if ispc
  minX = (nSamplesExpected/500)/fs_in;
  minY = -1;
else
  minX = (nSamplesExpected/500)/fs_in;
  minY = -1+1e-4;
end

timeSec = nSamplesExpected/fs_in;
xticks = tickLocations(timeSec);

xticknums = xticks;

if max(timeSec)<1
    xticknums = xticknums*1000;
end

xticklabels = cell(size(xticknums));
for ii = 1:length(xticknums)
    xticklabels{ii} = sprintf('%0.0f', xticknums(ii));
end

for chan = 1:plotData.nChannels
    plotData.subplot(chan) = axes('position', pos{chan}, 'xtick', [], 'ytick', [], ...
        'xlim', [1 nSamplesExpected]/fs_in, 'ylim', [-1 1], ...
        'drawmode', 'fast', 'ticklength', [0 0], ...
        'xcolor', get(f,'color'), 'ycolor', get(f,'color'),  'ButtonDownFcn', {'clickOnSubplot',chan});
    
    % grid lines for all plots
    for ticknum = 2:length(xticks)
        plotData.xgrid(chan).line(ticknum) = line([xticks(ticknum) xticks(ticknum)], [-1 1], ...
            'parent', plotData.subplot(chan),'hittest','off', 'visible', 'on', 'color', [.75 .75 .75]);
    end

    % waveform plots
    %plotData.plot{1}(chan) = waveformPlotInit(nSamplesExpected, plotData.subplot(chan));

    plotData.waveform(chan).axis.x = line([1 nSamplesExpected]/fs_in, [0 0], ...
            'color', [0 0 0], 'parent', plotData.subplot(chan),'hittest','off');
    plotData.waveform(chan).axis.y = line([minX minX], [-1 1], ...
            'color', [0 0 0],'parent',plotData.subplot(chan),'hittest','off');
    plotData.waveform(chan).line = line(0, 0, 'parent', plotData.subplot(chan),'hittest','off', 'visible', 'off');
    plotData.waveform(chan).dots = line(0, 0, 'marker', '.', 'linestyle', 'none', 'parent', plotData.subplot(chan),'hittest','off', 'visible', 'off');

    % axis labels for waveforms
    if chan==plotData.nChannels
        plotData.ylabels.waveform.handles(1) = text(0, -1, sprintf('%0.2f', -1/state.dataGainRaw*1000), ...
                'parent', plotData.subplot(chan), 'hittest', 'off', 'visible', 'on', ...
                'horizontalalignment', 'right', 'verticalalignment', 'middle');
        plotData.ylabels.waveform.handles(2) = text(0, 1, sprintf('%0.2f', 1/state.dataGainRaw*1000), ...
                'parent', plotData.subplot(chan), 'hittest', 'off', 'visible', 'on', ...
                'horizontalalignment', 'right', 'verticalalignment', 'middle');
        plotData.ylabels.waveform.handles(3) = text(0, 0.5, 'x10^{-3}', ...
                'parent', plotData.subplot(chan), 'hittest', 'off', 'visible', 'on', ...
                'horizontalalignment', 'right', 'verticalalignment', 'middle');
        state.plot.currentGain = state.dataGainRaw;
    else
        plotData.ylabels.waveform.handles = [];
    end

    plotData.waveform(chan).handles = [plotData.waveform(chan).axis.x plotData.waveform(chan).axis.y ...
                            plotData.waveform(chan).line plotData.waveform(chan).dots ...
                            plotData.ylabels.waveform.handles];
    plotData.waveform(chan).dataHandles = [plotData.waveform(chan).line plotData.waveform(chan).dots];


    % raster plots
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

    % psthes
    psthY = zeros(size(plotData.psthX));
    plotData.psth(chan).axis.x = line([1 nSamplesExpected]/fs_in, [minY minY], ...
        'color', [0 0 0], 'parent', plotData.subplot(chan),'hittest','off', 'visible', 'off');
    plotData.psth(chan).axis.y = line([minX minX], [-1 1], ...
        'color', [0 0 0],'parent',plotData.subplot(chan),'hittest','off', 'visible', 'off');
    plotData.psth(chan).line = line(plotData.psthX, psthY, 'parent', plotData.subplot(chan),'hittest','off', 'visible', 'off');
    
    % axis labels for psthes
    plotData.psth(chan).labelHandles(1) = text(0, -1, '0', ...
            'parent', plotData.subplot(chan), 'hittest', 'off', 'visible', 'off', ...
            'horizontalalignment', 'right', 'verticalalignment', 'middle');
    plotData.psth(chan).labelHandles(2) = text(0, 1, '0', ...
            'parent', plotData.subplot(chan), 'hittest', 'off', 'visible', 'off', ...
            'horizontalalignment', 'right', 'verticalalignment', 'middle');

    plotData.psth(chan).handles = [plotData.psth(chan).axis.x plotData.psth(chan).axis.y plotData.psth(chan).line ...
                                plotData.psth(chan).labelHandles];
    plotData.psth(chan).dataHandles = [plotData.psth(chan).line];

    % lfp running average plot
    plotData.lfp(chan).axis.x = line([1 nSamplesExpected]/fs_in, [0 0], ...
        'color', [0 0 0], 'parent', plotData.subplot(chan),'hittest','off', 'visible', 'off');
    plotData.lfp(chan).axis.y = line([minX minX], [-1 1], ...
        'color', [0 0 0],'parent',plotData.subplot(chan),'hittest','off', 'visible', 'off');
    plotData.lfp(chan).line = line(0, 0, 'parent', plotData.subplot(chan),'hittest','off', 'visible', 'off');
    set(plotData.lfp(chan).line, 'XData', state.onlineData.lfp.keptSampleTimes);
    plotData.lfp(chan).handles = [plotData.lfp(chan).axis.x plotData.lfp(chan).axis.y plotData.lfp(chan).line];
    plotData.lfp(chan).dataHandles = [plotData.lfp(chan).line];
    plotData.lfpGain = 1;

    % % tuning plot
    % if isfield(grid, 'tuningPlotInitFunction')
    %     plotData.tuning(chan) = feval(grid.tuningPlotInitFunction, grid, chan);
    % end
    
    % time axis for all plot types
    if chan==plotData.nChannels
        for ticknum = 1:length(xticks)
            plotData.xlabels(chan).xlabels(ticknum) = text(xticks(ticknum), -1, xticklabels(ticknum), ...
                'parent', plotData.subplot(chan), 'hittest', 'off', 'visible', 'on', ...
                'horizontalalignment', 'center', 'verticalalignment', 'top');
        end
    end

    plotData.activeHandles{chan} = plotData.waveform(chan).handles;
end
%keyboard;
state.plot.typeShouldChange = true;
state.plot.activeChannelShouldChange = true;
state.plot.shouldDisable = false;
plotData.firstSweep = true;
plotData.lastDrawTime = 0;
plotData.nSweeps = 0;



