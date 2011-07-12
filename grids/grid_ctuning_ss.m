function grid = grid_ctuning_ss()

  % controlling the sound presentation
  grid.stimGenerationFunctionName = 'loadStereo';
  grid.stimDir = 'D:\auditory-objects\sounds.calib.expt%E\%N\%P-%N\';
  grid.sampleRate = 24414.0625*2;  % ~50kHz

  % essentials
  grid.name = 'ctuning.ss';
  grid.stimFilename = ...
      'special_sound.is_smoothed.%1.token.%2.embedded.%3.%L.f32';
  
  % stimulus grid structure
  grid.stimGridTitles = {'Smoothed', 'Token', 'Embedded', 'Level'};
  
  smoothedIdxs = 0; % use 0 if not smoothed, 1 if smoothed, 0:1 if both
  tokenIdxs = 1:10;
  embeddedIdxs = 0:1;
  levels = 70;
  
  grid.stimGrid = createPermutationGrid(smoothedIdxs, tokenIdxs, embeddedIdxs, levels);  
  
  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 2;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = -102;
  
