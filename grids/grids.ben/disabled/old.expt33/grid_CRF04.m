function grid = grid_CRF04()

  % controlling the sound presentation
  grid.stimGenerationFunctionName = 'loadStereo';
  grid.stimDir = 'E:\auditory-objects\sounds.calib.expt%E\%N\';
  grid.sampleRate = 24414.0625*2;  % ~50kHz

  % essentials
  grid.name = 'CRF04';
  grid.stimFilename = 'mode.%1.BF.%2.token.%3.%L.f32';
  
  % stimulus grid structure
  grid.stimGridTitles = {'Mode', 'BF', 'Token', 'Level'};

  grid.stimGrid = createPermutationGrid(5, 0, 0:9, 80);

  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 10;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = [-97, -92];
  
