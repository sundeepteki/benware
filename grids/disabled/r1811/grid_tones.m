function grid = grid_tones

  % essentials
  grid.name = 'tones';

  % controlling the sound presentation
  grid.initFunction = 'loadStimSet';
  grid.stimGenerationFunctionName = 'getStimFromSet';
  grid.setFile = 'e:\christian\thesis\chapter 2\experiments\anesthetized\animals\R1811\sets\Calibrated\Tones_Anesthetized4_calib.mat';
  grid.sampleRate = 24414.0625*4;  % ~100kHz
  grid.monoStim = true;

  % stimulus grid structure
  grid.stimGridTitles = {'StimID', 'Level'};
  grid.stimGrid = createPermutationGrid(1:21, [85 75 65 55]);
  
  % sweep parameters
  grid.sweepLength = 0.5; % seconds
  grid.repeatsPerCondition = 10;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = -75;
  