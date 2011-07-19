function [stim, stimInfo] = loadStereo(sweepNum, grid, expt)
% [stim, stimInfo] = loadStereo(sweepNum, grid, expt)
%
% Load a pair of stimulus files. The correct stimulus files are found by
% finding experiment parameters in the grid and expt structures, and 
% using constructStimPath to replace % tokens with appropriate values
% (sweepNum, etc)
% 
% sweepNum, grid, expt: standard benWare variables

global truncate

fprintf(['  * Loading stimulus ' num2str(sweepNum) '...']);

% generate stimInfo structure
stimInfo.sweepNum = sweepNum;
stimInfo.stimGridTitles = grid.stimGridTitles;
stimInfo.stimParameters = grid.randomisedGrid(sweepNum, :);
stimInfo.stimFileL = constructStimPath(grid, expt, sweepNum, 'L');
stimInfo.stimFileR = constructStimPath(grid, expt, sweepNum, 'R');

% load the stimulus
stim = loadStim(stimInfo.stimFileL, stimInfo.stimFileR, ...
		grid.stimLevelOffsetDB + stimInfo.stimParameters(end));

% hack to present 1 second stimulus instead of 30
if truncate > 0
    fprintf(' ==Truncating stimulus== ');
    stim = stim(:, 1:round(truncate*grid.sampleRate)); 
end

fprintf(['done after ' num2str(toc) ' sec.\n']);