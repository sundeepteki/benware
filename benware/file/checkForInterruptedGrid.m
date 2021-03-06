function [gridFile, lastSweep] = checkForInterruptedGrid(exptDir, expt)
% determine whether the most recently saved directory
% in exptDir represents an unfinished grid. if so, return it and the 
% number of sweeps that were successfully run

gridFile = [];
lastSweep = 0;

try

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

    % check whether its from the current experiment (we won't offer to resume 
    % if the user has changed experiment)
    if (gridInfo.expt.exptNum~=expt.exptNum)
      return;
    end

    % check whether its from the current penetration (we won't offer to resume 
    % if the user has changed penetration)
    if (gridInfo.expt.penetrationNum~=expt.penetrationNum)
      return;
    end

    if gridInfo.grid.repeatsPerCondition==Inf
      % then 'infinite' repeats were specified, i.e. it's a search grid
      return;
    end

    filename = constructDataPath(...
      [gridInfo.expt.dataDir gridInfo.expt.sweepFilename], ...
       gridInfo.grid, gridInfo.expt, gridInfo.grid.nSweepsDesired);

    if exist(filename, 'file')
      % then the last grid is complete
      return;

    else
      for ii = 1:gridInfo.grid.nSweepsDesired
        filename = constructDataPath(...
          [gridInfo.expt.dataDir gridInfo.expt.sweepFilename], ...
           gridInfo.grid, gridInfo.expt, ii);
        if ~exist(filename, 'file')
          break
        end
      end
      gridFile = [exptDir newestDir.name filesep 'gridInfo.mat'];
      lastSweep = ii-1;
    end

catch
    return;
end
