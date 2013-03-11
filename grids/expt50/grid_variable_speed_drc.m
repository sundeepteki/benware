function grid = grid_variable_speed_drc()

  % controlling the sound presentation
  grid.stimGenerationFunctionName = 'loadStimAndCompensate';
  grid.stimDir = 'e:\auditory-objects\sounds-uncalib\variable_speed_drc_v2\';
  %grid.stimDir = '/Users/ben/scratch/texture/texture.v2/renamed/';
  grid.sampleRate = 24414.0625*2;  % ~50kHz

  % essentials
  grid.name = 'variable_speed_drc';
  grid.stimFilename = 'drc.%1.contrast.%2.variable.%3.f32';
  
  % stimulus grid structure
  grid.stimGridTitles = {'Token', 'Contrast', 'Variable', 'Level'};  
  grid.stimGrid = createPermutationGrid(1:4, 30, [0 1], 80);
    
  % compensation filter
  grid.initFunction = 'loadCompensationFilters';
  grid.compensationFilterFile = ...
    'e:\auditory-objects\calibration\calib.expt42\compensationFilters.mat';
  %grid.compensationFilterFile = ...
  %  '/Users/ben/scratch/expt.42/calib.expt42/compensationFilters.mat';

  grid.compensationFilterVarNames = {'compensationFilters.L', 'compensationFilters.R'};

  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 7;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = [3 3];
  