function [stim, stimInfo] = loadStimAndCompensate(sweepNum, grid, expt)
% [stim, stimInfo] = loadWavAndCompensate(sweepNum, grid, expt)
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
% Ideally, this would hash the files and store the compensated versions, so
% the compensation is not redone every sweep

% generate stimInfo structure
stimInfo.sweepNum = sweepNum;
stimInfo.stimGridTitles = grid.stimGridTitles;
stimInfo.stimParameters = grid.randomisedGrid(sweepNum, :);
stimInfo.stimFile = constructStimPath(grid, expt, sweepNum);

fprintf(['  * Getting stimulus ' num2str(sweepNum) ' from ' escapepath(stimInfo.stimFile) '...']);

% get hashes of stimulus and compensation filters
hashoptions.Input = 'file';
stimhash = DataHash(stimInfo.stimFile, hashoptions);
filterhash = DataHash(grid.compensationFilters);

cacheDir = sprintf('.%sstimcache%s', filesep, filesep);
cacheName = sprintf('%s%s.%s.mat', cacheDir,  stimhash, filterhash);

if exist(cacheName, 'file')
	% load from cache
	fprintf('\n  * loading compensated version from cache...')
	s = load(cacheName);
	stim = s.stim;
	
else
	fprintf('\n  * compensating...\n');

	% load the stimulus
	if strcmp(stimInfo.stimFile(end-3:end), '.f32')
		uncalib = read32(stimInfo.stimFile);
	elseif strcmp(stimInfo.stimFile(end-3:end), '.wav')
		uncalib = wavread(stimInfo.stimFile);
	end

	% apply compensation filter
	for chan = 1:length(grid.compensationFilters)
		stim(chan, :) = conv(uncalib, grid.compensationFilters{chan});
	end

	% save in cache
	if ~exist(cacheDir, 'dir')
		mkdir(cacheDir);
	end

	fprintf('  * saving compensated version to cache...')
	save(cacheName, 'stim');

end

% apply level offset
for chan = 1:length(grid.compensationFilters)
	stim(chan, :) = stim(chan, :) * 10^(grid.stimLevelOffsetDB(chan) / 20);
end

fprintf(['done after ' num2str(toc) ' sec.\n']);

