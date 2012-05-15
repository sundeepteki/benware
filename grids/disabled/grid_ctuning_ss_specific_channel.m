function grid = grid_ctuning_ss_specific_channel()

  % controlling the sound presentation
  grid.stimGenerationFunctionName = 'loadStereo';
  grid.stimDir = ['E:\auditory-objects\sounds.calib.expt%E\%N\%P-%N\'];
  grid.sampleRate = 24414.0625*2;  % ~50kHz

  % essentials
  grid.name = 'ctuning.ss';
  grid.stimFilename = ...
      'special_sound.is_smoothed.%1.token.%2.embedded.%3.source_channel.%4.%L.f32';
  
  % stimulus grid structure
  grid.stimGridTitles = {'Smoothed', 'Token', 'Embedded', 'SourceChannel', 'Level'};
  
  smoothedIdxs = 0; % use 0 if not smoothed, 1 if smoothed, 0:1 if both
  tokenIdxs = 1:10;
  embeddedIdxs = 0;
  levels = 70;
  sourceChannels = [22, 7, 25];
  
  grid.stimGrid = createPermutationGrid(smoothedIdxs, tokenIdxs, embeddedIdxs, sourceChannels, levels);

  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 2;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = [-97, -92];
  
