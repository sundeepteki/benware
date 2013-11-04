function grid = grid_joshpitch()

  % controlling the sound presentation
  grid.sampleRate = 24414.0625*4;  % ~100kHz
  grid.stimGenerationFunctionName = 'loadStimAndCompensate';
  grid.stimDir = 'e:\auditory-objects\sounds-uncalib\joshpitch\';
  grid.stimFilename = 'KerryPitchSounds2013_%1.wav';
  
  % stimulus grid structure
  grid.stimGridTitles = {'ID'};  
  grid.stimGrid = [createPermutationGrid(1:15, 80); ... % 4 conditions, three tokens for basic characterisation. repeat twice
                    ];

%   fprintf('Calibration only!!\n');
%   pause;
%   grid.stimGrid = [1 80];
  
  % compensation filter
  grid.initFunction = 'loadCompensationFilters';
  grid.compensationFilterFile = ...
    'e:\auditory-objects\calibration\calib.ben.03.11.13\compensationFilters.mat';
  %grid.compensationFilterFile = ...
  %  '/Users/ben/scratch/expt.42/calib.expt42/compensationFilters100k.mat';

  grid.compensationFilterVarNames = {'compensationFilters.L', 'compensationFilters.R'};

  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 10;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = [13 13]-44;
  