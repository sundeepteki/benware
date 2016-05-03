function grid = grid_decorr()

  % controlling the sound presentation
  grid.sampleRate = 24414.0625*4;  % ~100kHz
  grid.stimGenerationFunctionName = 'loadStimAndCompensate';
  grid.stimDir = 'e:\auditory-objects\sounds-uncalib\decorr.v1\';
  grid.stimFilename = 'drc.cond.%1.token.%2.f32';
  
  % stimulus grid structure
  grid.stimGridTitles = {'Condition', 'Token', 'Level'};  
  grid.stimGrid = [createPermutationGrid(1:4, 1:3, 85); ... % 4 conditions, three tokens for basic characterisation. repeat twice
                    createPermutationGrid(5:12, 1, 85); ... % conditions 5-12 have only 1 token. repeat 6 times
                    createPermutationGrid(5:12, 1, 85); ... % conditions 5-12 have only 1 token. repeat 6 times
                    createPermutationGrid(5:12, 1, 85); ... % conditions 5-12 have only 1 token. repeat 6 times
                    ];

%   fprintf('Calibration only!!\n');
%   pause;
%   grid.stimGrid = [4 1 80]; % switching contrast, loud
  
  % compensation filter
  grid.initFunction = 'loadCompensationFilters';
  grid.compensationFilterFile = ...
    'e:\auditory-objects\calibration\calib.ben.2013.04.27\compensationFilters.mat';
  %grid.compensationFilterFile = ...
  %  '/Users/ben/scratch/expt.42/calib.expt42/compensationFilters100k.mat';

  grid.compensationFilterVarNames = {'compensationFilters.L', 'compensationFilters.R'};

  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 10;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = [13 13]-27;
  