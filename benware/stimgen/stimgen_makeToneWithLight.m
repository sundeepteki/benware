function stim = stimgen_makeCalibToneWithLight(expt, grid, ...
	duration, freq, delay, len, lightvoltage, lightdelay, lightduration, level)
	%% stim = stimgen_makeCalibTone(expt, grid, varargin)
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

	stimLen_samples = ceil(duration/1000*grid.sampleRate);
	% time
	t = 0:1/grid.sampleRate:len/1000;

	% sinusoid
	tone = sin(2*pi*freq*t);
	delay = zeros(1, ceil(delay/1000*grid.sampleRate));
	remainder = zeros(1, (stimLen_samples-length(tone)-length(delay)));

	% ramp up and down
	ramplen_samples = round(5/1000*grid.sampleRate);
	ramp = (1-cos(pi*(1:ramplen_samples)/ramplen_samples))/2;
	env = [ramp ones(1,length(tone)-2*length(ramp)) fliplr(ramp)];
	tone = tone.*env;

	uncalib = [delay tone remainder];
	uncalib = repmat(uncalib, [nChannels-1, 1]);

	% set level correctly
	uncalib = uncalib*sqrt(2);
	uncalib = uncalib * 10^((level-94) / 20);

	% light in last channel
	lightdelay = ceil(lightdelay/1000*grid.sampleRate);
	lightduration = ceil(lightduration/1000*grid.sampleRate);
	lightstim = zeros(1, stimLen_samples);
	lightstim(1, lightdelay:min(stimLen_samples, lightdelay+lightduration-1)) = lightvoltage;

	stim = uncalib;
	stim(nChannels, :) = lightstim;
