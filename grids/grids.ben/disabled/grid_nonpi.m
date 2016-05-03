function grid = grid_nonpi()

  % controlling the sound presentation
  grid.sampleRate = 24414.0625*2;  % ~50kHz
  grid.stimGenerationFunctionName = 'loadStereoStimAndCompensate';
  grid.stimDir = 'e:\auditory-objects\sounds-uncalib\no-npi\';
  grid.stimFilename = 'no_npi.gap.%1.token.%2.wav';
  
  % stimulus grid structure
  grid.stimGridTitles = {'Gap (ms)', 'Token', 'Level'};  
  grid.stimGrid = createPermutationGrid([25 400], 1:8, 80); 
  
  % compensation filter
  grid.initFunction = 'loadCompensationFilters';
  grid.compensationFilterFile = ...
    'e:\auditory-objects\calibration\calib.ben.2013.04.27\compensationFilters.mat';
  %grid.compensationFilterFile = ...
  %  '/Users/ben/scratch/expt.42/calib.expt42/compensationFilters.mat';

  grid.compensationFilterVarNames = {'compensationFilters.L', 'compensationFilters.R'};

  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 2;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = [13 13]-108;
  