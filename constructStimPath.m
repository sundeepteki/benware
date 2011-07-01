function path = constructStimPath(grid, expt, sweepNum, side)
% path = constructStimPath(grid, expt, sweepNum, side)
%
% Works out stimulus filenames, replacing % tokens where necessary.
%
% grid, expt: standard benWare data structures
% sweepNum: the sweep number
% side: headphone for which stimulus is destined
% 
% The % tokens (for stim paths) are:
% %E = expt number, e.g. '29'
% %1, %2... %9 = stimulus parameter value
% %N = grid name
% %L = left or right (for stimulus file)
% %P = penetration number
% %S = sweep number
% %C = channel number
% 
% Note, this doesn't quite match constructDataPath -- it doesn't allow 
% you to operate on an arbitrary path. This might need fixing.

stimParameters = grid.randomisedGrid(sweepNum, :);

% construct template
path = [grid.stimDir grid.stimFilename];

% replace main parts of path
for ii = 1:length(stimParameters)-1
  path = regexprep(path, ['%' num2str(ii)], num2str(stimParameters(ii)));
end
path = regexprep(path, '%E', num2str(expt.exptNum));
path = regexprep(path, '%P', ['P' num2str(expt.penetrationNum, '%02d')]);
path = regexprep(path, '%N', grid.name);

% optional side
if exist('side', 'var')
  path = regexprep(path, '%L', side);
end
