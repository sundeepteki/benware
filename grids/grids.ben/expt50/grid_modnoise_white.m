function grid = grid_modnoise_white()

  % controlling the sound presentation
  grid.stimGenerationFunctionName = 'loadStimAndCompensate';
  grid.stimDir = 'e:\auditory-objects\sounds-uncalib\modnoise\';
  %grid.stimDir = '/Users/ben/scratch/texture/texture.v2/renamed/';
  grid.sampleRate = 24414.0625*2;  % ~50kHz

  % essentials
  grid.stimFilename = 'McD_STRF_stim_WHITE_%1.wav';
  
  % stimulus grid structure
  grid.stimGridTitles = {'Sound ID', 'Level'};  
  grid.stimGrid = createPermutationGrid(1:6, 80);
  
  % compensation filter
  grid.initFunction = 'loadCompensationFilters';
  grid.compensationFilterFile = ...
    'e:\auditory-objects\calibration\calib.expt42\compensationFilters.mat';
  grid.compensationFilterVarNames = {'compensationFilters.L', 'compensationFilters.R'};

  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 10;
  
  % set this using absolute calibration
  % RMS of modnoise is equal to texture.v2
  grid.stimLevelOffsetDB = [3 3];
  