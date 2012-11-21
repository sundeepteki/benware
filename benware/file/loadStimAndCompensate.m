function [stim, stimInfo] = loadStimAndCompensate(sweepNum, grid, expt)
% [stim, stimInfo] = loadWavAndCompensate(sweepNum, grid, expt)
%
% Load an f32 or wav file and compensate using however many compensation
% filters are available. The correct stimulus files are found by
% finding experiment parameters in the grid and expt structures, and 
% using constructStimPath to replace % tokens with appropriate values
% (sweepNum, etc)
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

% load the stimulus
if strcmp(stimInfo.stimFile(end-3:end), '.f32')
	uncalib = read32(stimInfo.stimFile);
elseif strcmp(stimInfo.stimFile(end-3:end), '.wav')
	uncalib = wavread(stimInfo.stimFile);
end

identifyingSamples = 1:floor(length(uncalib)/10):length(uncalib);
stimID = sum(diff(uncalib(identifyingSamples)));

filterID = 0;
for chan = 1:length(grid.compensationFilters)
	identifyingSamples = 1:floor(length(grid.compensationFilters{chan})/10):length(grid.compensationFilters{chan});
	filterID = filterID + sum(diff(grid.compensationFilters{chan}(identifyingSamples)));
end

%safeName = regexprep(stimInfo.stimFile, filesep, '.');
%safeName = regexprep(safeName, ':', '.');
%if safeName(1)== '.'
%	safeName = safeName(2:end);
%end

%cacheNameEnd = sprintf('.%0.8f.%0.8f.mat', stimID, filterID);
%cacheName = ['.' cacheNameEnd];
if 0 %%exist(cacheName, 'file')
	% load from cache
	fprintf('loading compensated version from cache...')
	s = load(cacheName);
	stim = s.stim;
	
else
	fprintf('compensating...');
	% apply compensation filter
	for chan = 1:length(grid.compensationFilters)
		stim(chan, :) = conv(uncalib, grid.compensationFilters{chan});
	end

	% save in cache
	%if ~exist(['.' filesep 'stimcache'], 'dir')
	%	mkdir(['.' filesep 'stimcache']);
	%end

	%fprintf('saving compensated version to cache...')
	%save(cacheName, 'stim');

end

% apply level offset
for chan = 1:length(grid.compensationFilters)
	stim(chan, :) = stim(chan, :) * 10^(grid.stimLevelOffsetDB(chan) / 20);
end

fprintf(['done after ' num2str(toc) ' sec.\n']);

