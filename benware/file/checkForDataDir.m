function dirExists = checkForDataDir(grid,expt)
% probably deprecated

fullPath = expt.dataDir;

fullPath = regexprep(fullPath,'%E',num2str(expt.exptNum));
fullPath = regexprep(fullPath,'%P',['P' num2str(expt.penetrationNum,'%02d')]);
fullPath = regexprep(fullPath,'%N',num2str(grid.name));

dirExists = false;

if exist(fullPath,'dir')
    dirExists = true;
end
