function grid = loadStimSet(grid, expt)
% load christian-style stim set
% don't use if you're not christian

l = load(grid.setFile);
grid.stim_set = l.stim_set;

