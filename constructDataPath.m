function path = constructDataPath(pathTemplate,grid,expt,sweepNum,channelNum)

path = regexprep(pathTemplate,'%E',num2str(expt.exptNum));
path = regexprep(path,'%P',['P' num2str(expt.penetrationNum,'%02d')]);

if isempty(grid.altName)
    path = regexprep(path,'%N',num2str(grid.name));
else
    path = regexprep(path,'%N',num2str(grid.altName));
end

if exist('sweepNum','var')
    path = regexprep(path,'%S',num2str(sweepNum));
end

if exist('channelNum','var')
    path = regexprep(path,'%C',num2str(channelNum,'%02d'));
end