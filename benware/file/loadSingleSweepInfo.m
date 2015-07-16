function sweep = loadSingleSweepInfo(sweep, grid, expt, sweepNum)
% loadSingleSweepInfo(sweeps, grid, expt)
%
% Load data from one sweep from the appropriate place

filename = constructDataPath([expt.dataDir expt.sweepFilename], grid, expt, sweepNum);
dirname = split_path(filename);
l = load(filename);
sweep = l.sweep;
