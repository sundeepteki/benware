function grid = grid_rss

  % essentials
  grid.name = 'rss_headphone';

  % controlling the sound presentation
  grid.initFunction = 'loadStimSetAndCal';
  grid.stimGenerationFunctionName = 'getStimFromSetAndCompensate';
  grid.setFile = 'e:\christian\thesis\chapter 2\experiments\anesthetized\animals\R1911\sets\Calibrated\RSS_sub_Anesthetized4_calib.mat';
  grid.sampleRate = 24414.0625*4;  % ~50kHz
  grid.monoStim = true;

  % stimulus grid structure
  grid.stimGridTitles = {'StimID', 'Level'};
  grid.stimGrid = createPermutationGrid(1:132, 75);
  
  % sweep parameters
  grid.sweepLength = 0.5; % seconds
  grid.repeatsPerCondition = 20;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = -75;
