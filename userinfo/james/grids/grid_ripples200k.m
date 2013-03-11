function grid = grid_ripples200k()

  % controlling the sound presentation
  grid.stimGenerationFunctionName = 'loadStimAndCompensate';
  grid.stimDir = 'e:\James\stimuli\';
  %grid.stimDir = '/Users/ben/scratch/texture/texture.v2/renamed/';
  grid.sampleRate = 24414.0625*8;  % ~200kHz

  % essentials
  grid.name = 'ripple200k';
  % drc1_contrast10.f32
  grid.stimFilename = 'rippleseg%1.wav';
  
  % stimulus grid structure
  grid.stimGridTitles = {'ID', 'Level'};  
  %grid.stimGrid = createPermutationGrid(1:5, 1:7, 80); 
  grid.stimGrid = createPermutationGrid(1:15, 80); 

  % for calibration
  %grid.stimGrid = createPermutationGrid(9, 9, 80);
  
  % compensation filter
  grid.initFunction = 'loadCompensationFilters';
  grid.compensationFilterFile = ...
    'e:\auditory-objects\calibration\james-01\calibL_200k.mat';

  grid.compensationFilterVarNames = {'calibL_200k.filter'};

  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 10;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = [3 3];
  