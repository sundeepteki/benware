function grid = grid_bubd_bb_calib()

  % controlling the sound presentation
  grid.stimGenerationFunctionName = 'loadStereo';
  grid.stimDir = 'E:\auditory-objects\sounds.calib.expt%E\bubd_bb\';
  grid.sampleRate = 24414.0625*2;  % ~50kHz

  % essentials
  grid.name = 'bubd_bb.83dB';
  grid.stimFilename = 'bubd_bb.id.%1.token.%2.%L.f32';
  
  % stimulus grid structure
  grid.stimGridTitles = {'ID', 'Token', 'Level'};
  grid.stimGrid = [440 1 90];
  
  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = Inf;
  grid.saveWaveforms = false;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = [-128,-129.5];
