function stim = stimgen_CSDProbeWithLight(expt, grid, ...
 	duration, delay, len, lightvoltage, lightdelay, lightduration, level)
	%% stim = makeCSDprobeWithLight(expt, grid, ...
 	%%    duration, delay, len, lightvoltage, lightdelay, lightduration, level)
	%%
	%% This is a model for new-style (2016 onward) benware stimulus generation functions
	%%
	%% The stimulus generation function will be called (by prepareStimulus) as:
	%%   uncomp = stimgen_function(expt, grid, parameters{:})
	%% where 'parameters' is a row from grid.stimGrid, so the parameters are values
	%% of the stimulus parameters specified in grid.stimGridTitles.
	%% 
	%% Stimulus generation functions must obey the following rules:
	%% 
	%% 1. Must have a name that begins stimgen_
	%% 2. Accept parameters:
	%%      expt: standard benware expt structure (as loaded by loadexpt.m)
	%%      grid: standard benware grid structure (produced by grid_*.m)
	%%      varargin: a list of parameters, whose length matches
	%%            the length of grid.stimGridTitles
	%% 3. Produces a matrix containing uncalibrated sound, meeting these criteria:
	%%      A. The sample rate must match grid.sampleRate
	%%      B. The first dimension of this matrix must match expt.nStimChannels.
	%%      C. The values are measured in Pascals, so that a sound with an RMS of 1
	%%         corresponds to 1 Pascal RMS, or 94 dB SPL.

	%% get parameters
	sampleRate = grid.sampleRate;
	nChannels = expt.nStimChannels;

	% convert times to samples
	duration = ceil(duration/1000*grid.sampleRate);
	delay = round(delay/1000*grid.sampleRate);
	len = round(len/1000*grid.sampleRate);
	lightdelay = ceil(lightdelay/1000*grid.sampleRate);
	lightduration = ceil(lightduration/1000*grid.sampleRate);

	stimLen_samples = duration*trials;

	rand_trial=randperm(trials); %shuffle trials

	% sound in channel 1
	uncalib = zeros(1, stimLen_samples);

	for n=1:trials
		uncalib(1, (n*duration-duration)+delay(rand_trial(n)):(n*duration-duration)+delay(rand_trial(n))+len-1) = randn(1, len); 
	end

	stim = repmat(uncalib, [nChannels-1 1]);

	% light in channel 2
	lightstim = zeros(1, stimLen_samples);
	lightstim(1, lightdelay:min(stimLen_samples, lightdelay+lightduration-1)) = lightvoltage;

	stim(2,:) = lightstim;

	% set level correctly
	uncalib = uncalib*sqrt(2);
	uncalib = uncalib * 10^((level-94) / 20);

	stim(1,:) = repmat(uncalib, 1, 1);
