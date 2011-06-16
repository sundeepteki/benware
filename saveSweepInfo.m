function saveSweepInfo(sweeps, grid, expt)
  % saveSweepInfo(sweeps, grid, expt)

fprintf(['  * Saving sweep metadata...']);

dataDir = constructDataPath(expt.dataDir, grid, expt);
fullPath = [dataDir 'sweepInfo.mat'];

if exist(fullPath, 'file')
    movefile(fullPath, [fullPath '.old']);
end

saved = false;
while ~saved
  try
    save(fullPath, 'sweeps', '-v6');    
    saved = true;
  catch
    fprintf(['couldn''t save, trying again']);
  end
end
  
fprintf(['done.\n']);