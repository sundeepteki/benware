function grid = grid_drc

  % essentials
  grid.name = 'drc';

  % controlling the sound presentation
  grid.initFunction = 'loadStimSetAndCalib';
  grid.stimGenerationFunctionName = 'getStimFromSetAndCompensate';
  grid.setFile = 'e:\christian\thesis\chapter 2\experiments\anesthetized\animals\R1911\sets\Calibrated\DRCs_Anesthetized_stand_small4_calib.mat';
  grid.sampleRate = 24414.0625*4;  % ~100kHz
  grid.monoStim = true;

  % stimulus grid structure
  grid.stimGridTitles = {'StimID', 'Level'};
  grid.stimGrid = createPermutationGrid(1:2, 75);
  
  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 15;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = -120;
