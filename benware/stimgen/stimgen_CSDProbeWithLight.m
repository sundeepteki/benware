function stim = makeCSDprobeWithLight(expt, grid, ...
 	duration, delay, len, light_voltage, light_delay, light_duration, level)
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
	light_delay = ceil(light_delay/1000*grid.sampleRate);
	light_duration = ceil(light_duration/1000*grid.sampleRate);


    %% get sound file with one less channel that expt.nStimChannels (because the last
    %% channel will be used for the light)
    new_expt = expt;
    new_expt.nStimChannels = expt.nStimChannels - 1;

    % remove light_voltage from grid.stimGridTitles and from the parameter list
    % so that these are now in the format expected by stimgen_loadSoundfile.m
    new_grid = grid;
    valid_idx = [1 2 3 7]; % parameters we want to pass on to stimgen_CSDprobe.m
    new_grid.stimGridTitles = new_grid.stimGridTitles(valid_idx);
    new_varargin = varargin(valid_idx);
    stim = stimgen_CSDprobe(new_expt, new_grid, new_varargin{:});


	%% light in last channel
	lightstim = zeros(1, stimLen_samples);
	lightstim(1, lightdelay:min(stimLen_samples, lightdelay+lightduration-1)) = lightvoltage;

	stim(nChannels,:) = lightstim;
