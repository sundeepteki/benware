function grid = grid_rumpel()

  % controlling the sound presentation
  grid.sampleRate = 24414.0625*8;  % ~200kHz
  grid.stimGenerationFunctionName = 'loadStimAndCompensateWithLight';
  grid.stimDir = 'e:\auditory-objects\sounds-uncalib\rumpel\';
  %grid.stimDir = '/Users/ben/scratch/texture/texture.v2/renamed/';
  grid.stimFilename = 'rumpel-%1.wav';
  
  % stimulus grid structure
  grid.stimGridTitles = {'ID', 'Light voltage', 'Level'};  
  %grid.stimGrid = createPermutationGrid(1:5, 1:7, [0 5], 80); 
  grid.stimGrid = createPermutationGrid(1:34, 0, 80); 

  % for calibration
  %grid.stimGrid = createPermutationGrid(9, 9, 80);
%   fprintf('For calibration only!\n');
%   pause;
%   grid.stimGrid = createPermutationGrid(1, [10], 25, 0, 80); 

% compensation filter
  grid.initFunction = 'loadCompensationFilters';
  grid.compensationFilterFile = ...
    'e:\auditory-objects\calibration\vifa.10.09.13\calibL_200k.mat';
  grid.compensationFilterVarNames = {'calibL_200k.filter'};

  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 50;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = [6-18 0];
  