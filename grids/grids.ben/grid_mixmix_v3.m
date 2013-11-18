function grid = grid_mixmix_v2()

  % controlling the sound presentation
  grid.sampleRate = 24414.0625*2;  % ~50kHz
  grid.stimGenerationFunctionName = 'loadStimAndCompensate';
  grid.stimDir = 'e:\auditory-objects\sounds-uncalib\mixmix\';
  %grid.stimDir = '/Users/ben/scratch/texture/texture.v2/renamed/';
  grid.stimFilename = 'mixmix.mix.%1.%2.wav';
  
  % stimulus grid structure
  grid.stimGridTitles = {'Mixture', 'Sound ID', 'Level'};  
  grid.stimGrid = createPermutationGrid([0 1], 1:16, 80);
  
    global CALIBRATE;
    if CALIBRATE
        fprintf('== Calibration mode. Press a key to continue == ')
        pause;
        grid.stimGrid = createPermutationGrid(1, 1, 80); 
    end
    
  % compensation filter
  grid.initFunction = 'loadCompensationFilters';
  grid.compensationFilterFile = ...
    'e:\auditory-objects\calibration\calib.ben.18.11.2013\compensationFilters.mat'; % 50kHz
  %grid.compensationFilterFile = ...
  %  '/Users/ben/scratch/expt.42/calib.expt42/compensationFilters.mat';

  grid.compensationFilterVarNames = {'compensationFilters.L', 'compensationFilters.R'};

  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 20;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = [13 11]+1;
  