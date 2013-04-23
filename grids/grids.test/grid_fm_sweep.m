function grid = grid_fm_sweep()

  % controlling the sound presentation
  grid.sampleRate = 24414.0625*4;  % ~100kHz
  grid.stimGenerationFunctionName = 'makeFMSweep';
  
  % stimulus grid structure
  grid.stimGridTitles = {'Duration', 'F0', 'F1', 'Level'};

  grid.stimGrid = [10000 500 32000 80];

  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 30;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = [-104, -106]+120;
    
  % compensation filter
  %grid.initFunction = 'loadCompensationFilters';
  %grid.compensationFilterFile = ...
  %  'e:\auditory-objects\calibration\calib.expt51\compensationFilters.100k.mat';
  %grid.compensationFilterVarNames = {'compensationFilters.L', 'compensationFilters.R'};
