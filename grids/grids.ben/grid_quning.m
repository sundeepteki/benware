function grid = grid_quning()

  % controlling the sound presentation
  grid.sampleRate = 24414.0625*4;  % ~100kHz
  grid.stimGenerationFunctionName = 'makeCalibTone';
  
  % stimulus grid structure
  grid.stimGridTitles = {'Frequency', 'Duration', 'Level'};

  % frequencies and levels
  freqs = logspace(log10(500), log10(500*2^5.75), 5.75*4+1);  
  levels = 50:20:90;
  tonedur = 200;

%   fprintf('Calibration only!\n');
%   pause;
%   freqs = [1000];
%   levels = 80;
%   tonedur = 1000;

  grid.stimGrid = createPermutationGrid(freqs, tonedur, levels);

  % sweep parameters
  grid.postStimSilence = 0.4;
  grid.repeatsPerCondition = 30;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = [0 0]-16-35;
  
  % compensation filters
  grid.initFunction = 'loadCompensationFilters';
  grid.compensationFilterFile = ...
    'e:\auditory-objects\calibration\calib.ben.03.11.13\compensationFilters.mat';
  grid.compensationFilterVarNames = {'compensationFilters.L', 'compensationFilters.R'};
