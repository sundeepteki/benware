function grid = grid_environmental_calib()
  % for calibrating environmental sounds

  % controlling the sound presentation
  grid.stimGenerationFunctionName = 'loadStereo';
  grid.stimDir = 'E:\auditory-objects\sounds.calib.expt%E\%N\';
  grid.sampleRate = 24414.0625*2;  % ~50kHz

  % essentials
  grid.name = 'environmental';
  grid.stimFilename = 'source.%1.mode.%2.BF.%3.token.%4.set.%5.stimnum.%6.%L.f32';
  
  % stimulus grid structure
  grid.stimGridTitles = {'Source', 'Mode', 'BF', 'Token', 'Set', 'StimID', 'NominalLevel', 'Level'};

  grid.stimGrid = [2, 0, 0, 0, 1, 1, 82, -38];
  grid.stimGrid = [2, 0, 0, 0, 1, 2, 80, -40];
  grid.stimGrid = [2, 0, 0, 0, 1, 3, 80, -40];
  grid.stimGrid = [2, 0, 0, 0, 1, 4, 80, -40];
  grid.stimGrid = [2, 0, 0, 0, 1, 5, 80, -40];
  grid.stimGrid = [2, 0, 0, 0, 1, 6, 80, -40];
  grid.stimGrid = [2, 0, 0, 0, 1, 7, 75, -45];
  grid.stimGrid = [2, 0, 0, 0, 1, 8, 80, -40];
  
  % sweep parameters
  grid.postStimSilence = 0.2;
  grid.repeatsPerCondition = 10;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = [-5, 0];
  
