function grid = grid_dadida()

  % controlling the sound presentation
  grid.stimGenerationFunctionName = 'make_and_compensate_dadida';
  grid.sampleRate = 24414.0625*4;  % ~100kHz

  % essentials
  grid.name = 'dadida';
  
  % best frequency of current neurons
  bf = 5000; % Hz

  % stimulus grid structure
  % stimseq(sampleRate,Afreq,Aamp,Bfreq,Bamp,tondur,ncycles,prestim)
  grid.stimGridTitles = {'BF (Hz)', 'Delta_f (oct)', ...
      'f0 condition (1-5)', 'B offset', 'B random', 'N test cycles (A)', 'N test cycles (B)', ...
      'Prestim', 'Level'};

  %grid.stimGrid = [createPermutationGrid(bf, 0.5, 1, 100,   1, 0, 10, 0, 80)];

  grid.stimGrid = [createPermutationGrid(bf, [0.5 1], 1:5, 100, 0, 10,10, 0, 80); ... % unprimed ABA
                   createPermutationGrid(bf, [0.5 1], 1:5, 100, 0, 10,10, 1, 80); ... % primed ABA
                   createPermutationGrid(bf, [0.5 1], 1:5, 100, 0, 10,10, 2, 80); ... % interrupt ABA
                   createPermutationGrid(bf, [0.5 1], 1:5, 0,   0, 10,10, 0, 80); ... % unprimed sync
                   createPermutationGrid(bf, [0.5 1], 1:5, 0,   1, 10,10, 0, 80); ... % unprimed random

                   createPermutationGrid(bf, [0.5 1], 1,   0,   0, 10, 0, 1, 80); ... % primed As only
                   createPermutationGrid(bf, [0.5 1], 1, 100,   0, 0, 10, 1, 80); ... % primed Bs only
                   createPermutationGrid(bf, [0.5 1], 1, 100,   0, 10, 0, 2, 80); ... % primed interrupt A's only
                   createPermutationGrid(bf, [0.5 1], 1, 100,   0, 0, 10, 2, 80); ... % primed interrupt B's only
                   createPermutationGrid(bf, [0.5 1], 1, 100,   0, 10, 0, 0, 80); ... % unprimed A's only
                   createPermutationGrid(bf, [0.5 1], 1, 100,   0, 0, 10, 0, 80); ... % unprimed B's only
                   createPermutationGrid(bf, [0.5 1], 1, 100,   1, 0, 10, 0, 80); ... % unprimed Bs random
                   ];

  grid.stimulusConstants.Agap = 100;
  grid.stimulusConstants.Bgap = 100;
  grid.stimulusConstants.tondur = 75;
  grid.stimulusConstants.intdur = 25;
  grid.stimulusConstants.nprecycles = 3;
  grid.stimulusConstants.randomseed = 5;
      
  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 15;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = -112;
  
  % compensation filter
  grid.initFunction = 'loadCompensationFilters';
  %grid.compensationFilterFile = ...
  %  'e:\auditory-objects\calibration\calib.expt42\compensationFilters.mat';
  grid.compensationFilterFile = ...
    '../expt.42/calib.expt42/compensationFilters.mat';
  grid.compensationFilterVarNames = {'compensationFilters.L', 'compensationFilters.R'};
