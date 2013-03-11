function grid = grid_dadida()

  % controlling the sound presentation
  grid.stimGenerationFunctionName = 'make_and_compensate_dadida';
  grid.sampleRate = 24414.0625*2;  % ~100kHz
  
  % best frequency of current neurons
  bf = 5000; % Hz

  % stimulus grid structure
  % stimseq(sampleRate,Afreq,Aamp,Bfreq,Bamp,tondur,ncycles,prestim)
  grid.stimGridTitles = {'BF (Hz)', 'Delta_f (oct)', ...
      'f0 condition (1-5)', 'B offset', 'Prestim type', 'Interrupted prestim', ...
      'B random', 'Level'};

  grid.stimGrid = [createPermutationGrid(bf, [0.5 1], 1:5, 100, 1, 0, 0, 80); ...
                   createPermutationGrid(bf, [0.5 1], 1:5, 100, 1, 1, 0, 80); ...
                   createPermutationGrid(bf, [0.5 1], 1:5, 100, 0, 0, 0, 80); ...
                   createPermutationGrid(bf, [0.5 1], 1:5, 0,   0, 0, 0, 80); ...
                   createPermutationGrid(bf, [0.5 1], 1:5, 0,   0, 0, 1, 80); ...
                      ];

  grid.stimulusConstants.gapA = 100;
  grid.stimulusConstants.gapB = 100;
  grid.stimulusConstants.tonedur = 75;
  grid.stimulusConstants.interval = 25;
  grid.stimulusConstants.n_prestim_cycles = 3;
  grid.stimulusConstants.n_test_cycles = 5;
  grid.stimulusConstants.randomseed = 110876;
      
  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 10;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = -112;
  
  % compensation filter
  grid.initFunction = 'loadCompensationFilters';
  %grid.compensationFilterFile = ...
  %  'e:\auditory-objects\calibration\calib.expt42\compensationFilters.mat';
  grid.compensationFilterFile = ...
    '../expt.42/calib.expt42/compensationFilters.mat';
  grid.compensationFilterVarNames = {'compensationFilters.L', 'compensationFilters.R'};
