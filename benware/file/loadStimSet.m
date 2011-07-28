function grid = loadStimSet(grid, expt)

l = load(grid.setFile);
grid.stim_set = l.stim_set;

