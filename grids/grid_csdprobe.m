function grid = grid_csdprobe()

  grid.stimGenerationFunctionName = 'makeCSDprobe';
  % stimGenerationFunction is the name of a matlab function
  % which will be called by benware to produce the stimuli, i.e.:
  % stim = stimGenerationFunction(expt, grid, grid.sampleRate, expt.nStimChannels, ...
  %      grid.compensationFilters, parameters{:});
  %
  % Inputs:
  % expt, grid are standard BenWare structures. Most stimulus generation functions
  %   won't need to use these.
  % grid.SampleRate is the stimulus sample rate, see below
  % expt.nStimChannels is the number of stimulus channels that stimGenerationFunction must produce
  %   i.e. usually 1 or 2
  % grid.compensationFilters is a structure containing compensation filters, which can
  %   be used by stimGenerationFunction to correct for speaker frequency response
  %
  % Output:
  % stimGenerationFunction must produce an nChannels x nSamples matrix containing the stimulus

  grid.sampleRate = 24414.0625*4; % must be a valid TDT sample rate
  
  grid.stimGridTitles = {'Stimulus Length (ms)', 'Delay (ms)'; 'Noise Length (ms)', 'Level'};
  % names of parameters in the stimulus grid

  grid.stimGrid = [490 50 10 80];
  % values of the above parameters. Each row defines one set of parameters, so the number
  % of *different* stimuli is the number of rows in this grid

  grid.postStimSilence = 0; % do you want to record responses to silence after the end of the stimulus?
                            % value is in milliseconds

  grid.repeatsPerCondition = Inf; % number of repeats of each stimulus
  
  grid.stimLevelOffsetDB = -112;  % offset that will be applied to the stimulus; can be a scalar
                                  % or a vector with a different value for each channel
