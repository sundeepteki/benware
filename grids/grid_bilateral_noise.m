function grid = grid_bilateral_noise

  % essentials
  grid.name = 'bilateral.noise';

  % controlling the sound presentation
  grid.stimGenerationFunctionName = 'makeBilateralNoise';
  grid.sampleRate = 24414.0625*2;  % ~50kHz

  % stimulus grid structure
  grid.stimGridTitles = {'Duration', 'LeftDelay', 'RightDelay', 'BothDelay', 'Level'};
  grid.stimGrid = [50 0 100 200 90];
  
  % sweep parameters
  grid.postStimSilence = 0.2; %seconds
  
  % search mode
  grid.repeatsPerCondition = Inf;
  grid.saveWaveforms = false;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = [-124 -129];
