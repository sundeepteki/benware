function grid = grid_ripples200k()

  % controlling the sound presentation
  grid.sampleRate = 24414.0625*8;  % ~200kHz
  grid.stimGenerationFunctionName = 'loadStimAndCompensateWithLight';
  grid.stimDir = 'e:\James\stimuli\';
  %grid.stimDir = '/Users/ben/scratch/texture/texture.v2/renamed/';
  grid.stimFilename = 'rippleseg%1.wav';
  
  % stimulus grid structure
  grid.stimGridTitles = {'ID', 'Light voltage', 'Level'};  
  %grid.stimGrid = createPermutationGrid(1:5, 1:7, 80); 
  grid.stimGrid = createPermutationGrid(1:15, [0 5], 80); 

  % for calibration
  %grid.stimGrid = createPermutationGrid(9, 9, 80);
  
  % compensation filter
  grid.initFunction = 'loadCompensationFilters';
  grid.compensationFilterFile = ...
    'e:\auditory-objects\calibration\expt26-21/10/13\calibL_200k.mat';

  grid.compensationFilterVarNames = {'calibL_200k.filter'};

  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 10;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = [-3+ 0];
  