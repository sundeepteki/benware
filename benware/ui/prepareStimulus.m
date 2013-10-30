function [stim, stimInfo] = prepareStimulus(stimGenerationFunction, sweepNum, grid, expt)
% generate stimInfo (stimulus parameters) for a given sweep, and
% pass parameters to specified stimGenerationFunction which generates
% stimulus vectors.
% Finally, add stimLevelOffsetDB to the stimulus for absolute calibration

stimInfo.stimGridTitles = grid.stimGridTitles;
stimInfo.stimParameters = grid.randomisedGrid(sweepNum, :);

parameters = num2cell(stimInfo.stimParameters);

% generate stimulus vector/matrix
stim = feval(stimGenerationFunction, expt, grid, grid.sampleRate, expt.nStimChannels, ...
				grid.compensationFilters, parameters{:});

% check number of channels is correct
if size(stim, 1)~=expt.nStimChannels
	errorBeep('Stimulus function %s did not generate the correct number of channels (%d)', ...
				func2str(stimGenerationFunction), expt.nStimChannels);
end

% apply level offset
level_offset = grid.stimLevelOffsetDB;
if length(level_offset)==1
	level_offset = repmat(level_offset, 1, size(stim, 1));
end

for chan = 1:size(stim, 1)
  stim(chan, :) = stim(chan, :) * 10^(level_offset(chan) / 20);
end
