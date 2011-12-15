function grid = grid_drc_headphones

  % essentials
  grid.name = 'drc_headphones';

  % controlling the sound presentation
  grid.initFunction = 'loadStimSetAndCal';
  grid.stimGenerationFunctionName = 'getStimFromSetAndCompensate';
  grid.setFile = 'e:\christian\thesis\chapter 2\experiments\anesthetized\animals\R1811\sets\Calibrated\DRCs_Anesthetized_stand_large4_calib.mat';
  grid.sampleRate = 24414.0625*4;  % ~50kHz
  grid.monoStim = true;
  grid.calibFile = 'e:\auditory-objects\calibration\calib.expt33\compensationFilters.100k.mat';

  % stimulus grid structure
  grid.stimGridTitles = {'StimID', 'Level'};
  grid.stimGrid = createPermutationGrid(1:2, 75);
  
  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 10;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = -100;
