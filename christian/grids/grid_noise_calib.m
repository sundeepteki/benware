function grid = grid_noise_calib

  % essentials
  grid.name = 'noise';

  % controlling the sound presentation
  grid.stimGenerationFunctionName = 'makeNoiseBurst';
  grid.sampleRate = 24414.0625*2;  % ~50kHz

  % stimulus grid structure
  grid.stimGridTitles = {'Duration', 'Level'};
  grid.stimGrid = [1000 80];
  
  % sweep parameters
  grid.postStimSilence = 0.05; %seconds
  
  % search mode
  grid.repeatsPerCondition = Inf;
  grid.saveWaveforms = true;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = -128;
