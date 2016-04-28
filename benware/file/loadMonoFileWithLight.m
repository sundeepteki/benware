function stim = loadMonoFileWithLight(expt, grid, sampleRate, nChannels, compensationFilters, varargin)
% function stim = loadMonoFileWithLight(sampleRate, nChannels, compensationFilters, filename)
%
% Load an f32 or wav file and add voltage to drive light
%
% The correct stimulus files are found by
% finding experiment parameters in the grid and expt structures, and 
% using constructStimPath to replace % tokens with appropriate values
% (sweepNum, etc)

stimParameters = cell2mat(varargin);
level = varargin{end};

filename = constructStimPath([grid.stimDir grid.stimFilename], ...
				expt.exptNum, expt.penetrationNum, grid.name, '', stimParameters);

fprintf(['  * Getting stimulus from ' escapepath(filename) '...']);

% load the stimulus
if strcmp(filename(end-3:end), '.f32')
    uncalib = readf32(filename)';
elseif strcmp(filename(end-3:end), '.wav')
    uncalib = audioread(filename)';
end

if size(uncalib,1)==1
    stim = uncalib;
else
    error('stimulus file has the wrong shape');
end

% add light
idx = strcmpi(grid.stimGridTitles, 'Light voltage');
stim(2, :) = [ones(1, length(stim)-100) zeros(1, 100)] * stimParameters(idx);

fprintf('done\n');
