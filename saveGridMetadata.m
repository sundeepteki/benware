function saveGridMetadata(grid,expt)

fprintf(['Saving grid metadata...']);

dataDir = constructDataPath(grid.dataDir,grid,expt);

fullPath = [dataDir 'gridInfo.mat'];

if ~exist(dataDir,'dir')
    mkdir(dataDir);
elseif exist(fullPath,'file')
    error(['Grid metadata file -- ' fullPath ' -- already exists']);
end

save(fullPath,'expt','grid');

fprintf(['done.\n']);