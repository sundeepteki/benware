function grid = ctuning_drc()

  % controlling the sound presentation
  grid.stimGenerationFunctionName = 'loadStereo';
  grid.stimDir = 'D:\auditory-objects\sounds.calib.expt%E\%N\';

  % essentials
  grid.name = 'ctuning.drc';
  grid.stimFilename = 'fw.%1.token.%2.naive.%L.f32';
  
  % stimulus grid structure
  grid.stimGridTitles = {'Fullwidth', 'Token', 'Level'};
  grid.stimGrid = [30, 1, 70];
  
  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 10;
  
  % set this using absolute calibration
  grid.stimLevelOffset = 30;
  