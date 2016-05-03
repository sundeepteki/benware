function grid = grid_texture_v3()

  % controlling the sound presentation
  grid.sampleRate = 24414.0625*2;  % ~50kHz
  grid.stimGenerationFunctionName = 'loadStimAndCompensate';
  grid.stimDir = 'e:\auditory-objects\sounds-uncalib\texture.v3\';
  %grid.stimDir = '/Users/ben/scratch/texture/texture.v2/renamed/';
  grid.stimFilename = 'texture.v3.id%1.type%2.wav';
  
  % stimulus grid structure
  grid.stimGridTitles = {'Sound ID', 'Condition', 'Level'};  
  grid.stimGrid = createPermutationGrid(1:5, 1:9, 80);

  %grid.stimGrid = createPermutationGrid(1:2, 1, 80); 
  
%   % for calibration
%   fprintf('== calibration only == ')
%   pause;
%   grid.stimGrid = createPermutationGrid(1, 1, 80);
  
  % compensation filter
  grid.initFunction = 'loadCompensationFilters';
  grid.compensationFilterFile = ...
    'e:\auditory-objects\calibration\calib.ben.03.11.13\compensationFilters.mat';
  %grid.compensationFilterFile = ...
  %  '/Users/ben/scratch/expt.42/calib.expt42/compensationFilters.mat';

  grid.compensationFilterVarNames = {'compensationFilters.L', 'compensationFilters.R'};

  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 7;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = [12 12]-25;
  