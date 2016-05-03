function grid = grid_texture()

  % controlling the sound presentation
  grid.stimGenerationFunctionName = 'loadStimAndCompensate';
  grid.stimDir = 'e:\auditory-objects\sounds-uncalib\texture.v1\';
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
    'e:\auditory-objects\calibration\calib.expt41/calibL_50k.mat';
  grid.compensationFilterVarNames = {'calibL_50k.filter'};

  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 25;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = 50;
  