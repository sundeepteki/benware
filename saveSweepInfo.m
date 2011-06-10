function saveSweepInfo(sweeps,dataDir,grid,expt)

fprintf(['Saving sweep metadata...']);

fullPath = [dataDir 'sweepInfo.mat'];
fullPath = regexprep(fullPath,'%E',num2str(expt.exptNum));
fullPath = regexprep(fullPath,'%P',['P' num2str(expt.penetrationNum,'%02d')]);
fullPath = regexprep(fullPath,'%N',num2str(grid.name));

if exist(fullPath,'file')
    movefile(fullPath,[fullPath '.old']);
end
save(fullPath,'sweeps');

fprintf(['done.\n']);