function grid = grid_vowels_twoformant

  % essentials
  grid.name = 'vowels_twoformant_headphone';

  % controlling the sound presentation
  grid.initFunction = 'loadStimSetAndCal';
  grid.stimGenerationFunctionName = 'getStimFromSetAndCompensate';
  grid.setFile = 'e:\christian\thesis\chapter 2\experiments\anesthetized\animals\R1811\sets\Calibrated\Vowels_TwoFormants_Anesthetized4_calib.mat';
  grid.sampleRate = 24414.0625*4;  % ~100kHz
  grid.monoStim = true;

  % stimulus grid structure
  grid.stimGridTitles = {'StimID', 'Level'};
  grid.stimGrid = createPermutationGrid(1:130, 75);
  
  % sweep parameters
  grid.sweepLength = 0.5; % seconds
  grid.repeatsPerCondition = 20;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = -75;
  