function relPath = saveSpikeTimes(spikeTimes, grid, expt, sweepNum)
% saveSpikeTimes(spikeTimes, grid, expt, sweepNum)
%
% Not currently used

fprintf(['  * Saving spike times...\n']);

% ensure target directory exists
dirTemplate = [expt.dataDir expt.spikeFilename];
fullPath = constructDataPath(dirTemplate, grid, expt, sweepNum);
dirName = split_path(fullPath);
mkdir_nowarning(dirName);

% save all spike times from this sweep in one mat file
save(fullPath, 'spikeTimes', '-v6');

% return relative path to the saved file
relPath = constructDataPath(expt.spikeFilename, grid, expt, sweepNum);

fprintf(['  * Done after ' num2str(toc) ' sec.\n']);
