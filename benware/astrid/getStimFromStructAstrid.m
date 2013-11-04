function [stim, stimInfo] = getStimFromStructAstrid(expt, grid, sampleRate, nChannels, compensationFilters, varargin)

  stimInfo.stimGridTitles = grid.stimGridTitles;
  stimInfo.stimParameters = cell2mat(varargin);
  assert(length(stimInfo.stimParameters)==2); % one for stimulus ID, one for level
  stimID = stimInfo.stimParameters(1);
  level = stimInfo.stimParameters(2);

  if size(grid.stimuli(stimID).L,1)>1
    stim = grid.stimuli(stimID).L';
    stim(2,:) = grid.stimuli(stimID).R';
  else
    stim = grid.stimuli(stimID).L;
    stim(2,:) = grid.stimuli(stimID).R;
  end

% correct level will be handled within createExperimentStimuli()
%   % apply level offset
%   for chan = 1:size(stim,1)
%      stim(chan, :) = stim(chan, :) * 10^((level-80) / 20);
%   end