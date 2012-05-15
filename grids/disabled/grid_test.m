function grid = grid_test()

  % controlling the sound presentation
  grid.stimGenerationFunctionName = 'loadStereo';
  grid.stimDir = '/data/contrast/tokens/frozen.naive.calib.expt%E/';
  grid.sampleRate = 24414.0625*2;  % ~50kHz

  % essentials
  grid.name = 'ctuning.drc';
  grid.stimFilename = 'fw.%1.token.%2.naive.%L.f32';
  
  % stimulus grid structure
  grid.stimGridTitles = {'Fullwidth', 'Token', 'Level'};
  grid.stimGrid = [30, 1, 70];
  
  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 100;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = -74;
