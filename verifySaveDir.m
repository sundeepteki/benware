function altName = verifySaveDir(grid,expt)
% determine whether the data directory specified by grid.name already
% exists. If it does, allow user to decide whether to delete it or
% to use an alternative directory (named .2 etc).

dataDir = constructDataPath(grid.dataDir(1:end-1),grid,expt);

if ~exist(dataDir,'dir')
    altName = '';
else
    lastFound = '';
    suffix = '.2';
    while exist([dataDir suffix],'dir')
        lastFound = suffix;
        suffix(2)=suffix(2)+1;
    end
    f = find(dataDir=='\');
    altDir = [dataDir(f(end)+1:end) suffix];
    fprintf(['Directory ' dataDir(f(end)+1:end) lastFound ' exists.\n']);
    r=input(['[o]verwrite or use [A]lternative ' altDir '? '],'s');
    if lower(r)=='o'
        r=input(['About to delete ' regexprep([dataDir lastFound],'\','\\\') '. Sure? [y/N]? '],'s');
        if lower(r)=='y'
            rmdir([dataDir lastFound],'s');
            altName = [grid.name lastFound];
        else
            error('For God''s sake, make up your mind.');
        end
    else
        altName = [grid.name suffix];
    end 
end
