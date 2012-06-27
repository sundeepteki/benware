function grid = grid_texture()

  % controlling the sound presentation
  grid.stimGenerationFunctionName = 'loadStimAndCompensate';
  grid.stimDir = '/Users/ben/scratch/texture/texture.v1/';
  grid.sampleRate = 24414.0625*2;  % ~50kHz

  % essentials
  grid.name = 'texture';
  grid.stimFilename = 'texture.id.%1.cond.%2.wav';
  
  % stimulus grid structure
  grid.stimGridTitles = {'Sound ID', 'Condition', 'Level'};  
  grid.stimGrid = createPermutationGrid(1:5, 1:3, 80); % csdprobe stimulus 

  % compensation filter
  grid.initFunction = 'loadCompensationFilters';
  grid.compensationFilterFile = ...
    '/Users/ben/scratch/reverb-stimulus/calibration/calib.expt39/compensationFilters.mat';
  grid.compensationFilterVarNames = {'compensationFilters.L'};

  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 25;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = [-82, -82];
  
