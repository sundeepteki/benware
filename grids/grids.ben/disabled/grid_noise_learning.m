function grid = grid_noise_learning()

  % controlling the sound presentation
  grid.sampleRate = 24414.0625*4;  % ~100kHz
  grid.stimGenerationFunctionName = 'get_noiselearning_stimuli';
  
  % stimulus grid structure
  grid.stimGridTitles = {'ID', 'Level'};
  grid.stimGrid = [2 80; 3 80; 2 80];

  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 1;
  grid.randomiseGrid = false;
  
  % set this using absolute calibration
  % (same as quning)
  grid.stimLevelOffsetDB = [-2 2];
  
  % compensation filter
  grid.initFunction = 'initNoiseLearning';
