function paths = constructDataPaths(pathTemplate, grid, expt, sweepNum, maxChannelNum)
% path = constructDataPaths(pathTemplate, grid, expt, sweepNum, maxChannelNum)
%
% Replaces % tokens in a data filename with appropriate values. The tokens are:
%
% As constructDataPath, but takes a maximum channel number as an input, 
% and generates a cell array of paths, one per channel. It's done this way
% just to be fast.
%
% pathTemplate: pathname containing % tokens
% grid, expt: standard benWare data structures
% sweepNum: the sweep number
% 
% The % tokens (for data paths) are:
% %E = expt number, e.g. '29'
% %1, %2... %9 = stimulus parameter value
% %N = grid name
% %L = left or right (for stimulus file)
% %P = penetration number
% %S = sweep number
% %C = channel number

path = regexprep(pathTemplate, '%E', n2s(expt.exptNum));
path = regexprep(path, '%P', ['P' n2s(expt.penetrationNum, 2)]);

if isempty(grid.saveName)
    path = regexprep(path, '%N', grid.name);
else
    path = regexprep(path, '%N', grid.saveName);
end

if exist('sweepNum', 'var')
    path = regexprep(path, '%S', n2s(sweepNum));
end

paths = cell(1,maxChannelNum);

f = findstr(path,'%C');
for channelNum = 1:maxChannelNum
  paths{channelNum} = fix_slashes([path(1:f-1) n2s(channelNum, 2) path(f+2:end)]);
end
