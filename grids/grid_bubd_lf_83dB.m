function grid = grid_bubd_lf_83dB()

  % controlling the sound presentation
  grid.stimGenerationFunctionName = 'loadStereo';
  grid.stimDir = 'E:\auditory-objects\sounds.calib.expt%E\bubd_lf\';
  grid.sampleRate = 24414.0625*2;  % ~50kHz

  % essentials
  grid.name = 'bubd_lf.83dB';
  grid.stimFilename = 'bubd_lf.id.%1.token.%2.%L.f32';
  
  % stimulus grid structure
  grid.stimGridTitles = {'ID', 'Token', 'Level'};
  grid.stimGrid = sortrows(combvec([601:684 686:690 692:699], 1:20, 83)');

  % sweep parameters
  grid.sweepLength = 2.2; % seconds
  grid.repeatsPerCondition = 1;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = [-111.5,-111.5];
