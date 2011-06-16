function saveSpikeTimes(spikeTimes, grid, expt, sweepNum)
% saveSpikeTimes(spikeTimes, grid, expt, sweepNum)

fprintf(['  * Saving spike times...\n']);

% ensure target directory exists
dirTemplate = [expt.dataDir expt.spikeFilename];
fullPath = constructDataPath(dirTemplate, grid, expt, sweepNum);
dirName = split_path(fullPath);
mkdir_nowarning(dirName);

% save all spike times from this sweep in one mat file
filename = constructDataPath(dirTemplate, grid, expt, sweepNum);
save(filename, 'spikeTimes', '-v6');

fprintf(['  * Done after ' num2str(toc) ' sec.\n']);
