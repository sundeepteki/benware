function saveSweepInfo(sweeps,grid,expt)

fprintf(['Saving sweep metadata...']);

dataDir = constructDataPath(grid.dataDir,grid,expt);
fullPath = [dataDir 'sweepInfo.mat'];

if exist(fullPath,'file')
    movefile(fullPath,[fullPath '.old']);
end
save(fullPath,'sweeps');

fprintf(['done.\n']);