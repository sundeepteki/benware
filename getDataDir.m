function fullPath = getDataDir(grid,expt)

fullPath = grid.dataDir;

fullPath = regexprep(fullPath,'%E',num2str(expt.exptNum));
fullPath = regexprep(fullPath,'%P',['P' num2str(expt.penetrationNum,'%02d')]);

if isempty(grid.altName)
    fullPath = regexprep(fullPath,'%N',num2str(grid.name));
else
    fullPath = regexprep(fullPath,'%N',num2str(grid.name));
end