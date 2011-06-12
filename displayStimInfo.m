function displayStimInfo(sweeps, grid, sweepNum)
  % displayStimInfo(stimInfo)
  %
  % prints to screen the stimulus properties

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
  
  % source files
  fprintf('\nSource files:\n');
  fprintf('  - %s\n', stimInfo.stimFileL);
  fprintf('  - %s\n', stimInfo.stimFileR);

  fprintf('\n');