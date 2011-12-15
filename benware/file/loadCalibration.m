function grid = loadCalibration(grid, expt)

load(grid.calibFile);
grid.compensationFilter = eval(grid.calibVar);
