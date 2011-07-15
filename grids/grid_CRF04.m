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

grid.stimGrid = [...
  4, 12, 0, 80; ...
  4, 12, 1, 80; ...
  4, 12, 2, 80; ...
  4, 12, 3, 80; ...
  4, 12, 4, 80; ...
  4, 12, 5, 80; ...
  4, 12, 6, 80; ...
  4, 12, 7, 80];

  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 10;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = -102;
  
