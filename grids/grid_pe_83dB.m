function grid = grid_pe()

  % controlling the sound presentation
  grid.stimGenerationFunctionName = 'loadStereo';
  grid.stimDir = 'E:\auditory-objects\sounds.calib.expt%E\pe\';
  grid.sampleRate = 24414.0625*2;  % ~50kHz

  % essentials
  grid.name = 'pe.83dB';
  grid.stimFilename = 'pe.id.%1.token.%2.%L.f32';
  
  % stimulus grid structure
  grid.stimGridTitles = {'ID', 'Token', 'Level'};
  grid.stimGrid = combvec(408:436, 1:50, 83)';
  
  % sweep parameters
  grid.sweepLength = .42;
  grid.repeatsPerCondition = 20;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = -84;
