function saveSweepInfo(sweeps, grid, expt)
  % saveSweepInfo(sweeps, grid, expt)

fprintf(['Saving sweep metadata...']);

dataDir = constructDataPath(expt.dataDir, grid, expt);
fullPath = [dataDir 'sweepInfo.mat'];

if exist(fullPath, 'file')
    movefile(fullPath, [fullPath '.old']);
end
save(fullPath, 'sweeps');

fprintf(['done.\n']);