function fullPath = getDataDir(grid,expt)
% deprecated, I think. Use constructDataPath instead

fullPath = expt.dataDir;

fullPath = regexprep(fullPath,'%E',num2str(expt.exptNum));
fullPath = regexprep(fullPath,'%P',['P' num2str(expt.penetrationNum,'%02d')]);

if isempty(grid.saveName)
    fullPath = regexprep(fullPath,'%N',num2str(grid.name));
else
    fullPath = regexprep(fullPath,'%N',num2str(grid.name));
end