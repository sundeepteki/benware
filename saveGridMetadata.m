function saveGridMetadata(grid, expt)
  % saveGridMetadata(grid, expt)

fprintf(['  * Saving grid metadata...']);

% target directory
dataDir = constructDataPath(expt.dataDir, grid, expt);
mkdir_nowarning(dataDir);

% target file
fullPath = [dataDir 'gridInfo.mat'];
if exist(fullPath, 'file')
    error(['Grid metadata file -- ' fullPath ' -- already exists']);
end

save(fullPath, 'expt', 'grid', '-v6');

fprintf(['done.\n']);