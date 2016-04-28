function stim = loadStereoFile(expt, grid, sampleRate, nChannels, compensationFilters, varargin)
% deprecated: use stimgen_loadSoundFile instead
%
% function stim = loadStereoFile(sampleRate, nChannels, compensationFilters, filename)
%
% Load an f32 or wav file.
% If the file is mono, duplicate to 2 channels.
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
    if isnan(uncalib);
        errorBeep('Failed to read file %s', filename);
    end
elseif strcmp(filename(end-3:end), '.wav')
    uncalib = audioread(filename)';
end

if size(uncalib,1)==2
    stim = uncalib;
elseif size(uncalib,1)==1
    stim(1,:) = uncalib;
    stim(2,:) = uncalib;
else
    error('stimulus file has the wrong shape');
end

fprintf('done\n');
