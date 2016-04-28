function grid = loadCalibration(grid, expt)
% don't use

load(grid.calibFile);
grid.compensationFilter = eval(grid.calibVar);
