function grid = grid_noise_screening()

  % controlling the sound presentation
  grid.sampleRate = 24414.0625*4;  % ~100kHz
  grid.stimGenerationFunctionName = 'get_noiselearning_stimuli';
  
  % best frequency of current neurons
  bf = 1000; % Hz

  % stimulus grid structure
  grid.stimGridTitles = {'ID', 'Level'};
  grid.stimGrid = [1 80];

  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 1;
  
  % set this using absolute calibration
  % (same as quning)
  grid.stimLevelOffsetDB = [-104 -106]+100;
  
  % compensation filter
  grid.initFunction = 'initNoiseLearning';
