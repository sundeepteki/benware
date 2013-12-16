function saveSingleSweepInfo(sweep, grid, expt, sweepNum)
% saveSweepInfo(sweeps, grid, expt)
%
% Save data from one sweep to the appropriate place

fprintf(['  * Saving sweep metadata...']);

filename = constructDataPath([expt.dataDir expt.sweepFilename], grid, expt, sweepNum);
dirname = split_path(filename);
mkdir_nowarning(dirname);

saved = false;
warned = false;
while ~saved
  try
    save(filename, 'sweep', '-v6');
    saved = true;
  catch
    if ~warned
      keyboard
      fprintf(['Couldn''t save, retrying.\n']);
      warned = true;
    end
  end
end
  
fprintf(['done.\n']);
