function path = constructDataPath(pathTemplate, grid, expt, sweepNum, ...
				  channelNum)
  % path = constructDataPath(pathTemplate, grid, expt, sweepNum,
  %                          channelNum)

path = regexprep(pathTemplate, '%E', n2s(expt.exptNum));
path = regexprep(path, '%P', ['P' n2s(expt.penetrationNum, 2)]);

if isempty(grid.altName)
    path = regexprep(path, '%N', grid.name);
else
    path = regexprep(path, '%N', grid.altName);
end

if exist('sweepNum', 'var')
    path = regexprep(path, '%S', n2s(sweepNum));
end

if exist('channelNum', 'var')
    path = regexprep(path, '%C', n2s(channelNum, 2));
end