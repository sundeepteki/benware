function grid = grid_texture_v2()

  % controlling the sound presentation
  grid.stimGenerationFunctionName = 'loadStimAndCompensate';
  grid.stimDir = 'e:\auditory-objects\sounds-uncalib\texture.v2\';
  grid.sampleRate = 24414.0625*2;  % ~50kHz

  % essentials
  grid.name = 'texture_v2';
  grid.stimFilename = 'texture.v2.id%1.type%2.wav';
  
  % stimulus grid structure
  grid.stimGridTitles = {'Sound ID', 'Condition', 'Level'};  
  grid.stimGrid = createPermutationGrid(1:5, 1:7, 80); 
  
  % for calibration
  %grid.stimGrid = createPermutationGrid(9, 9, 80);
  
  % compensation filter
  grid.initFunction = 'loadCompensationFilters';
  grid.compensationFilterFile = ...
    'e:\auditory-objects\calibration\calib.expt42\compensationFilters.mat';
  grid.compensationFilterVarNames = {'compensationFilters.L', 'compensationFilters.R'};

  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 7;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = [3 3];
  