function stim = loadStereoStimAndCompensate(expt, grid, sampleRate, nChannels, compensationFilters, varargin)
% [stim, stimInfo] = loadWavAndCompensate(sweepNum, grid, expt)
%
% Load a stereo f32 or wav file and compensate using however many compensation
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
% (path, exptNum, penNum, gridName, side, stimParameters)
stimParameters = cell2mat(varargin);
level = varargin{end};

filename = constructStimPath([grid.stimDir grid.stimFilename], ...
				expt.exptNum, expt.penetrationNum, grid.name, '', stimParameters);

fprintf(['  * Getting stimulus from ' escapepath(filename) '...']);

stim = loadStereoStimFileAndCompensate(filename, compensationFilters, [level level]);
