function grid = grid_drc200k_50ms()

  % controlling the sound presentation
  grid.sampleRate = 24414.0625*8;  % ~200kHz
  grid.stimGenerationFunctionName = 'loadStimAndCompensateWithLight';
  grid.stimDir = 'e:\auditory-objects\sounds-uncalib\mouse.drc.8\';
  %grid.stimDir = '/Users/ben/scratch/texture/texture.v2/renamed/';
  grid.stimFilename = 'drc%1_dur%3_contrast%2.f32';
  
  % stimulus grid structure
  grid.stimGridTitles = {'DRC ID', 'Contrast', 'Chord dur', 'Light voltage', 'Level'};
  
  voltage = 5; % voltage to use for light
  grid.stimGrid = createPermutationGrid(1:4, [10 20 30 40 99], 50, [0 voltage], 80);

  % for calibration
  %grid.stimGrid = createPermutationGrid(9, 9, 80);
%   fprintf('For calibration only!\n');
%   pause;
%   grid.stimGrid = createPermutationGrid(1, [10], 25, 0, 80); 

% compensation filter
  grid.initFunction = 'loadCompensationFilters';
  grid.compensationFilterFile = ...
    'e:\auditory-objects\calibration\expt32-11.11.13\calibL_200k.mat';
  grid.compensationFilterVarNames = {'calibL_200k.filter'};

  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 3;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = [15 0];
  