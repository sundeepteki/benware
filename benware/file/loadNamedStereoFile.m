function stim = loadNamedStereoFile(expt, grid, sampleRate, nChannels, compensationFilters, stimID)
% function stim = loadStereoFile(sampleRate, nChannels, compensationFilters, filename)
%
% Load an f32 or wav file.
% If the file is mono, duplicate to 2 channels.
%
% The correct stimulus files are found by
% finding experiment parameters in the grid and expt structures, and 
% using constructStimPath to replace % tokens with appropriate values
% (sweepNum, etc)

filename = grid.stimFiles{stimID};

fprintf(['  * Getting stimulus from ' escapepath(filename) '...']);

% load the stimulus
uncalib = wavread(filename)';

if size(uncalib,1)==2
    stim = uncalib;
elseif size(uncalib,1)==1
    stim(1,:) = uncalib;
    stim(2,:) = uncalib;
else
    error('stimulus file has the wrong shape');
end

fprintf('done\n');
