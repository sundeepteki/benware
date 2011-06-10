function saveGridMetadata(grid,expt)

fprintf(['Saving grid metadata...']);

fullPath = [grid.dataDir 'gridInfo.mat'];

fullPath = regexprep(fullPath,'%E',num2str(expt.exptNum));
fullPath = regexprep(fullPath,'%P',['P' num2str(expt.penetrationNum,'%02d')]);
fullPath = regexprep(fullPath,'%N',num2str(grid.name));

% create directory hierarchy if necessary
f = find(fullPath=='\');
dirname = fullPath(1:f(end))

if ~exist(dirname,'dir')
    mkdir(dirname);
elseif exist(fullPath,'file')
    error(['Grid metadata file -- ' fullPath ' -- already exists']);
end

save(fullPath,'expt','grid');

fprintf(['done.\n']);