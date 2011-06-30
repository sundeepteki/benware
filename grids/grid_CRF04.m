function grid = grid_CRF04()

  % controlling the sound presentation
  grid.stimGenerationFunctionName = 'loadStereo';
  grid.stimDir = 'D:\auditory-objects\sounds.calib.expt%E\%N\';
  grid.sampleRate = 24414.0625*2;  % ~50kHz

  % essentials
  grid.name = 'CRF04';
  grid.stimFilename = 'mode.%1.BF.%2.token.%3.%L.f32';
  
  % stimulus grid structure
  grid.stimGridTitles = {'Mode', 'BF', 'Token', 'Level'};
  grid.stimGrid = [...
    4, 14, 0, 80; ...
    4, 14, 1, 80; ...
    4, 14, 2, 80; ...
    4, 14, 3, 80; ...
    4, 14, 4, 80; ...
    4, 14, 5, 80; ...
    4, 14, 6, 80; ...
    4, 14, 7, 80; ...
    4, 14, 8, 80];

  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 10;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = -92;
  
