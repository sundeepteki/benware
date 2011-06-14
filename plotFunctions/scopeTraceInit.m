function plotData = scopeTraceInit(plotData)

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
figure(1);
clf;
for ii = 1:32
  %plotData.subplotHandles(ii) = subplot(8,4,ii);
    plotData.subplotHandles(ii) = axes('position', pos{ii});
end
