function path = constructStimPath(grid, expt, sweepNum, side)
  % path = constructStimPath(grid, expt, sweepNum)
  % path = constructStimPath(grid, expt, sweepNum, side)

stimParameters = grid.randomisedGrid(sweepNum, :);

% construct template
path = [grid.stimDir grid.stimFilename];

% replace main parts of path
for ii = 1:L(stimParameters)-1
  path = regexprep(path, ['%' n2s(ii)], n2s(stimParameters(ii)));
end
path = regexprep(path, '%E', n2s(expt.exptNum));
path = regexprep(path, '%P', ['P' n2s(expt.penetrationNum, 2)]);
path = regexprep(path, '%N', n2s(grid.name));

% optional side
if exist('side', 'var')
  path = regexprep(path, '%L', side);
end
