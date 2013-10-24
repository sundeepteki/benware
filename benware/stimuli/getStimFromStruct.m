function [stim, stimInfo] = getStimFromStruct(sweepNum, grid, expt)

  stimInfo.stimGridTitles = grid.stimGridTitles;
  stimInfo.stimParameters = grid.randomisedGrid(sweepNum, :);
  
  params = num2cell(stimInfo.stimParameters);
  assert(length(params)==2); % one for stimulus ID, one for level
  stimID = params(1);

  if size(grid.stimuli(stimID).L,1)>1
    stim = grid.stimuli(stimID).L';
    stim(2,:) = grid.stimuli(stimID).R';
  else
    stim = grid.stimuli(stimID).L;
    stim(2,:) = grid.stimuli(stimID).R;
  end