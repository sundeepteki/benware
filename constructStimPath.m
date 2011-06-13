function path = constructStimPath(grid, expt, sweepNum, side)
% path = constructStimPath(grid, expt, sweepNum)
% path = constructStimPath(grid, expt, sweepNum, side)

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
