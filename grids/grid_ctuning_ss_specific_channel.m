function grid = grid_ctuning_ss_specific_channel()

  grid.sourceChannel = 23;

  % controlling the sound presentation
  grid.stimGenerationFunctionName = 'loadStereo';
  grid.stimDir = ['D:\auditory-objects\sounds.calib.expt%E\%N\%P-%N.source_channel.' num2str(grid.sourceChannel) '\'];
  grid.sampleRate = 24414.0625*2;  % ~50kHz

  % essentials
  grid.name = 'ctuning.ss';
  grid.stimFilename = ...
      'special_sound.is_smoothed.%1.token.%2.embedded.%3.%L.f32';
  
  % stimulus grid structure
  grid.stimGridTitles = {'Smoothed', 'Token', 'Embedded', 'Level'};
  grid.stimGrid = [  
    0, 1, 0, 70; ...
    0, 1, 1, 70; ...
    0, 2, 0, 70; ...
    0, 2, 1, 70; ...
    0, 3, 0, 70; ...
    0, 3, 1, 70; ...
    0, 4, 0, 70; ...
    0, 4, 1, 70; ...
    0, 5, 0, 70; ...
    0, 5, 1, 70; ...
    0, 6, 0, 70; ...
    0, 6, 1, 70; ...
    0, 7, 0, 70; ...
    0, 7, 1, 70; ...
    0, 8, 0, 70; ...
    0, 8, 1, 70; ...
    0, 9, 0, 70; ...
    0, 9, 1, 70; ...
    0, 10, 0, 70; ...
    0, 10, 1, 70];  

  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 2;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = -92;
  