function grid = grid_vowels

  % essentials
  grid.name = 'vowels';

  % controlling the sound presentation
  grid.initFunction = 'loadStimSet';
  grid.stimGenerationFunctionName = 'getStimFromSet';
  grid.setFile = 'E:\Christian\Surgery\Stimuli\Sets\Calibrated\Vowels_Anesthetized3_FRS8.mat';
  grid.sampleRate = 24414.0625*4;  % ~50kHz

  % stimulus grid structure
  grid.stimGridTitles = {'StimID', 'Level'};
  grid.stimGrid = createPermutationGrid(1:55, 70);
  
  % sweep parameters
  grid.sweepLength = 0.5; % seconds
  grid.repeatsPerCondition = 20;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = -70;
