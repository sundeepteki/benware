function grid = loadStimSetAndCalib(grid, expt)

l = load(grid.setFile);
grid.stim_set = l.stim_set;
fprintf(['Loaded stimuli from ' escapepath(grid.setFile) '\n']);

l = load(grid.compensationFilterFile);
grid.compensationFilter = eval(['l.' grid.compensationFilterVar]);
fprintf(['Loaded compensation filter from ' escapepath(grid.compensationFilterFile) '\n']);
