function grid = grid_drc

  % essentials
  grid.name = 'drc_headphones';

  % controlling the sound presentation
  grid.initFunction = 'loadStimSetAndCal';
  grid.stimGenerationFunctionName = 'getStimFromSetAndCompensate';
  grid.setFile = 'e:\christian\thesis\chapter 2\experiments\anesthetized\animals\R1911\sets\Calibrated\DRCs_Anesthetized_stand_small4_calib.mat';
  grid.sampleRate = 24414.0625*4;  % ~50kHz
  grid.monoStim = true;

  % stimulus grid structure
  grid.stimGridTitles = {'StimID', 'Level'};
  grid.stimGrid = createPermutationGrid(1:2, 75);
  
  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 20;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = -55;
