function [stim, stimInfo] = getStimFromSet(sweepNum, grid, expt)
% 
% sweepNum, grid, expt: standard benWare variables

fprintf(['  * Getting stimulus ' num2str(sweepNum) '...']);

% generate stimInfo structure
stimInfo.sweepNum = sweepNum;
stimInfo.stimGridTitles = grid.stimGridTitles;
stimInfo.stimParameters = grid.randomisedGrid(sweepNum, :);
%stimInfo.stimFileL = constructStimPath(grid, expt, sweepNum, 'L');
%stimInfo.stimFileR = constructStimPath(grid, expt, sweepNum, 'R');

stimIdx = stimInfo.stimParameters(1);
stimLevel = stimInfo.stimParameters(end);

% load the stimulus
stim = grid.stim_set.stimuli(stimIdx).abscalib ;

if size(stim,2)==1
  stim = stim';
end
stim = [stim; stim];
stim = stim*10^((stimLevel+grid.stimLevelOffsetDB)/20);

fprintf(['done after ' num2str(toc) ' sec.\n']);
