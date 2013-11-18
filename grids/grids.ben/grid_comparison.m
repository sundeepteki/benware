function grid = grid_comparison()

  % controlling the sound presentation
  grid.sampleRate = 24414.0625*4;  % ~100kHz
  grid.stimGenerationFunctionName = 'loadStimAndCompensate';
  grid.stimDir = 'e:\auditory-objects\sounds-uncalib\comparison\';
  grid.stimFilename = 'comparison.stimtype.%1.token.%2.wav';
  
  % stimulus grid structure
  grid.stimGridTitles = {'Stim type', 'Token', 'Level'};  
  grid.stimGrid = [createPermutationGrid(0, 1:2, 80); ... % fixed DRC
                    createPermutationGrid(1, 1:2, 80); ... % var DRC
                    createPermutationGrid(2, 1:3, 80); ... % TORC
                    createPermutationGrid(3, 1:2, 80); ... % modnoise                  
                    createPermutationGrid(4, 1:2, 80); ... % nat sounds
                    createPermutationGrid(6, 1:3, 80); ... % pure tones
                    ];

  global CALIBRATE;
  if CALIBRATE
   fprintf('Calibration only!!\n');
   pause;
   grid.stimGrid = [0 1 80];
  end
%   
  % compensation filter
  grid.initFunction = 'loadCompensationFilters';
  grid.compensationFilterFile = ...
    'e:\auditory-objects\calibration\calib.ben.18.11.2013\compensationFilters.100k.mat'; % 100kHz
  %grid.compensationFilterFile = ...
  %  '/Users/ben/scratch/expt.42/calib.expt42/compensationFilters100k.mat';

  grid.compensationFilterVarNames = {'compensationFilters.L', 'compensationFilters.R'};

  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 10;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = [13 13]-18-25+24;
  