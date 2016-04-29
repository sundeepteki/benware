function stim = stimgen_loadSoundFileWith20HzLightTrain(expt, grid, varargin)
    %% stim = stimgen_loadSoundFileWithLight(expt, grid, varargin)
    %%
    %% This function usess stimgen_loadSoundFile to load a sound and duplicated it
    %% to expt.nStimChannels-1, then adds a final channel containing a constant
    %% voltage to drive a light for optogenetics.
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
    %% 
    %% The correct stimulus files are found by
    %% finding experiment parameters in the grid and expt structures, and 
    %% using constructStimPath to replace % tokens with appropriate values
    %% (sweepNum, etc)

    %% get parameters
    sampleRate = grid.sampleRate;
    nChannels = expt.nStimChannels;

    try
        assert(length(varargin)==length(grid.stimGridTitles));
    catch
        error(['The number of parameters in the stimulus grid (columns in grid.stimGrid) does ' ...
               'not match the number of parameter titles (length of grid.stimGridTitles)']);
    end

    parameters = cell2mat(varargin);
    light_voltage_idx = find(strcmpi(grid.stimGridTitles, 'Light voltage'));
    light_voltage = parameters(light_voltage_idx);

    %% get sound file with one less channel that expt.nStimChannels (because the last
    %% channel will be used for the light)
    new_expt = expt;
    new_expt.nStimChannels = expt.nStimChannels - 1;

    % remove light_voltage from grid.stimGridTitles and from the parameter list
    % so that these are now in the format expected by stimgen_loadSoundfile.m
    new_grid = grid;
    valid_idx = setdiff(1:length(parameters), light_voltage_idx);
    new_grid.stimGridTitles = new_grid.stimGridTitles(valid_idx);
    new_varargin = varargin(valid_idx);
    stim = stimgen_loadSoundFile(new_expt, new_grid, new_varargin{:});

    % add light train
    train_construct= repmat([ones(1,(0.01*sampleRate)),zeros(1,(0.04*sampleRate))],1,801);%2hz 10ms pulses, 40 seconds long, 200 kHz 

    train=train_construct(1:length(stim));
    stim(nChannels, :) = train * light_voltage;
