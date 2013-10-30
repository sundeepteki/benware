function grid = grid_drc200k_plus_light()

  % controlling the sound presentation
  grid.sampleRate = 24414.0625*8;  % ~200kHz
  grid.stimGenerationFunctionName = 'loadStimAndCompensateWithLight';
  grid.stimDir = 'e:\auditory-objects\sounds-uncalib\mouse.drc.8\';
  %grid.stimDir = '/Users/ben/scratch/texture/texture.v2/renamed/';
  grid.stimFilename = 'drc%1_dur%3_contrast%2.f32';
  
  % stimulus grid structure
  grid.stimGridTitles = {'DRC ID', 'Contrast', 'Chord dur', 'Light voltage', 'Level'};  
  %grid.stimGrid = createPermutationGrid(1:5, 1:7, [0 5], 80); 
  grid.stimGrid = [createPermutationGrid(1:4, 40, [25 50], 0, 80); ...
%		createPermutationGrid(1:4, [10 20 30 40], 50, 0, 80); ...
%      		createPermutationGrid(1:4, 99, 50, 0, 80) ...
		];

  % for calibration
  %grid.stimGrid = createPermutationGrid(9, 9, 80);
%   fprintf('For calibration only!\n');
%   pause;
%   grid.stimGrid = createPermutationGrid(1, [10], 25, 0, 80); 

% compensation filter
  grid.initFunction = 'loadCompensationFilters';
  grid.compensationFilterFile = ...
    'e:\auditory-objects\calibration\expt26-21/10/13\calibL_200k.mat';
  grid.compensationFilterVarNames = {'calibL_200k.filter'};

  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 3;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = [6 0];
  