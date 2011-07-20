function grid = grid_bubd_hf_83dB()

  % controlling the sound presentation
  grid.stimGenerationFunctionName = 'loadStereo';
  grid.stimDir = 'E:\auditory-objects\sounds.calib.expt%E\bubd_hf\';
  grid.sampleRate = 24414.0625*2;  % ~50kHz

  % essentials
  grid.name = 'bubd_hf.83dB';
  grid.stimFilename = 'bubd_hf.id.%1.token.%2.%L.f32';
  
  % stimulus grid structure
  grid.stimGridTitles = {'ID', 'Token', 'Level'};
  grid.stimGrid = sortrows(combvec([701:784 786:790 792:799], 1:20, 83)');

  % sweep parameters
  grid.sweepLength = 2.2; % seconds
  grid.repeatsPerCondition = 1;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = -84;
