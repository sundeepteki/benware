function saveSweepInfo(sweeps, grid, expt)
% saveSweepInfo(sweeps, grid, expt)
%
% Save entire sweeps structure to disk. Slow, and therefore not currently used

fprintf(['  * Saving sweep metadata...']);

dataDir = constructDataPath(expt.dataDir, grid, expt);
fullPath = [dataDir 'sweepInfo.mat'];

if exist(fullPath, 'file')
    movefile(fullPath, [fullPath '.old']);
end

saved = false;
warned = false;
while ~saved
  try
    save(fullPath, 'sweeps', '-v6');
    saved = true;
  catch
    if ~warned
      fprintf(['Couldn''t save, retrying.\n']);
      warned = true;
    end
  end
end
  
fprintf(['done.\n']);
