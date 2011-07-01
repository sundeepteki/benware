function displayStimInfo(sweeps, grid, sweepNum)
% displayStimInfo(sweeps, grid, sweepNum)
%
% Prints to screen the stimulus properties
% Currently, this is special-cased to work with loadStereo. This might
% be better handled by having a field in the grid structure that allows
% selection of a function to print the stim info.

titleStr = sprintf('Sweep %d of %d', sweepNum, grid.nSweepsDesired);
fprintf_title(titleStr);

% display set info
setIdx = grid.randomisedGridSetIdx(sweepNum);
nSets = grid.nStimConditions;
repeatIdx = sum(grid.randomisedGridSetIdx(1:sweepNum) == setIdx);
nRepeats = grid.repeatsPerCondition;
fprintf('Set %d/%d, repeat %d/%d\n\n', setIdx, nSets, repeatIdx, nRepeats);

% display parameters
fprintf('Stimulus parameters:\n');
stimInfo = sweeps(sweepNum).stimInfo;
for ii=1:L(stimInfo.stimGridTitles)
  fprintf('  - %s: %d\n', stimInfo.stimGridTitles{ii}, ...
    stimInfo.stimParameters(ii));
end

if isequal(grid.stimGenerationFunctionName,'loadStereo')
  % source files
  fprintf('\nSource files:\n');
  fprintf('  - %s\n', stimInfo.stimFileL);
  fprintf('  - %s\n', stimInfo.stimFileR);
end

fprintf('\n');