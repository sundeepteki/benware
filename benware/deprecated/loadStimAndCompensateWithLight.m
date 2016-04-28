function stim = loadStimAndCompensateWithLight(expt, grid, sampleRate, nChannels, compensationFilters, varargin)
% function stim = loadStimAndCompensate(sampleRate, nChannels, compensationFilters, filename)
%
% Load a mono f32 or wav file and compensate using however many compensation
% filters are available. The correct stimulus files are found by
% finding experiment parameters in the grid and expt structures, and 
% using constructStimPath to replace % tokens with appropriate values
% (sweepNum, etc)
%
% This is the standard benware function for doing this job. Others may and do
% exist for special reasons, but this is usually the one to use.
% 
% sweepNum, grid, expt: standard benWare variables
%
% This is now powered by loadStimFileAndCompensate

% generate stimInfo structure
% stimInfo.sweepNum = sweepNum;
% stimInfo.stimGridTitles = grid.stimGridTitles;
% stimInfo.stimParameters = grid.randomisedGrid(sweepNum, :);
% stimInfo.stimFile = constructStimPath(grid, expt, sweepNum);

% (path, exptNum, penNum, gridName, side, stimParameters)
stimParameters = cell2mat(varargin);
level = varargin{end};

filename = constructStimPath([grid.stimDir grid.stimFilename], ...
				expt.exptNum, expt.penetrationNum, grid.name, '', stimParameters);

fprintf(['  * Getting stimulus from ' escapepath(filename) '...']);

stim = loadStimFileAndCompensate(filename, compensationFilters, level);

% add light
idx = strcmpi(grid.stimGridTitles, 'Light voltage');
stim(2, :) = [ones(1, length(stim)-100) zeros(1, 100)] * stimParameters(idx);
