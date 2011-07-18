function [gridFile, lastSweep] = checkForInterruptedGrid(exptDir, expt)
% determine whether the most recently saved directory
% in exptDir represents an unfinished grid. if so, return it and the 
% number of sweeps that were successfully run

gridFile = [];
lastSweep = 0;

% find the most recently created directory in the expt dir
newestDir = findNewestSubdir(exptDir);

if isempty(newestDir)
  return;
end

% load the grid from this directory
gridFilename = [exptDir newestDir.name filesep 'gridInfo.mat'];
if ~exist(gridFilename, 'file')
  return;
end

gridInfo = load(gridFilename);

filename = constructDataPath([gridInfo.expt.dataDir gridInfo.expt.sweepFilename], gridInfo.grid, gridInfo.expt, gridInfo.grid.nSweepsDesired);
if exist(filename, 'file')
  % then the last grid is complete
  return;
else
  for ii = 1:gridInfo.grid.nSweepsDesired
    filename = constructDataPath([gridInfo.expt.dataDir gridInfo.expt.sweepFilename], gridInfo.grid, gridInfo.expt, ii);
    if ~exist(filename, 'file')
      break
    end
  end
  gridFile = [exptDir newestDir.name filesep 'gridInfo.mat'];
  lastSweep = ii-1;
end
