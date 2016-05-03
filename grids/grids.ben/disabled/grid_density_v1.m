function grid = grid_density_v1()

  % controlling the sound presentation
  grid.sampleRate = 24414.0625*2;  % ~50kHz
  grid.stimGenerationFunctionName = 'loadStimAndCompensate';
  grid.stimDir = 'e:\auditory-objects\sounds-uncalib\density.v1\';
  %grid.stimDir = '/Users/ben/scratch/texture/texture.v2/renamed/';
  grid.stimFilename = 'drc.token.%1.density.%2.contrast.%3.f32';
  
  % stimulus grid structure
  grid.stimGridTitles = {'Token', 'Density', 'Contrast', 'Level'};  
  grid.stimGrid = createPermutationGrid(1:4, [1 3 5], 30, 80);
    
  % compensation filter
  grid.initFunction = 'loadCompensationFilters';
  grid.compensationFilterFile = ...
    'e:\auditory-objects\calibration\calib.ben.2013.04.27\compensationFilters.mat';
  %grid.compensationFilterFile = ...
  %  '/Users/ben/scratch/expt.42/calib.expt42/compensationFilters.mat';

  grid.compensationFilterVarNames = {'compensationFilters.L', 'compensationFilters.R'};

  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 7;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = [-84 -84]+77;
  