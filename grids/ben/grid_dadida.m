function grid = grid_dadida()

  % controlling the sound presentation
  grid.stimGenerationFunctionName = 'make_and_compensate_dadida';
  grid.sampleRate = 24414.0625*4;  % ~100kHz

  % essentials
  grid.name = 'dadida';
  
  % best frequency of current neurons
  bf = 1000; % Hz

  % stimulus grid structure
  % stimseq(sampleRate,Afreq,Aamp,Bfreq,Bamp,tondur,ncycles,prestim)
  grid.stimGridTitles = {'BF (Hz)', 'Delta_f (oct)', ...
      'f0 condition (1-5)', 'B offset', 'B random', 'N test cycles (A)', 'N test cycles (B)', ...
      'Prestim', 'B rand2', 'B dist', 'B sigma', 'Level'};

  %grid.stimGrid = [createPermutationGrid(bf, 0.5, 1, 100,   1, 0, 10, 0, 80)];

  grid.stimGrid = [createPermutationGrid(bf, [0.5 1], 1:5, 100, 0, 10,10, 0, 0, 0,  0, 80); ... % unprimed ABA
                   createPermutationGrid(bf, [0.5 1], 1:5, 100, 0, 10,10, 1, 0, 0,  0, 80); ... % primed ABA
                   createPermutationGrid(bf, [0.5 1], 1:5, 100, 0, 10,10, 2, 0, 0,  0, 80); ... % interrupt ABA
                   createPermutationGrid(bf, [0.5 1], 1:5, 0,   0, 10,10, 0, 0, 0,  0, 80); ... % unprimed sync
                   createPermutationGrid(bf, [0.5 1], 1:5, 100, 1, 10,10, 0, 1, 1, 50, 80); ... % unprimed random

                   createPermutationGrid(bf, [0.5 1],   1,   0, 0, 10, 0, 1, 0, 0,  0, 80); ... % primed As only
                   createPermutationGrid(bf, [0.5 1],   1, 100, 0, 0, 10, 1, 0, 0,  0, 80); ... % primed Bs only
                   createPermutationGrid(bf, [0.5 1],   1, 100, 0, 10, 0, 2, 0, 0,  0, 80); ... % primed interrupt A's only
                   createPermutationGrid(bf, [0.5 1],   1, 100, 0, 0, 10, 2, 0, 0,  0, 80); ... % primed interrupt B's only
                   createPermutationGrid(bf, [0.5 1],   1, 100, 0, 10, 0, 0, 0, 0,  0, 80); ... % unprimed A's only
                   createPermutationGrid(bf, [0.5 1],   1, 100, 0, 0, 10, 0, 0, 0,  0, 80); ... % unprimed B's only
                   createPermutationGrid(bf, [0.5 1],   1, 100, 1, 0, 10, 0, 1, 1, 50, 80); ... % unprimed Bs random

                   createPermutationGrid(bf, [1/12 2/12 3/12], 1:5, 100, 1, 10,10, 0, 1, 1, [0 12.5 50], 80); ... % unprimed random
                   createPermutationGrid(bf, [1/12 2/12 3/12], 1:5, 100, 1,  0,10, 0, 1, 1, [0 12.5 50], 80); ... % unprimed Bs only
                   ];

%   fprintf('Calibration only!\n');
%   grid.stimGrid = [createPermutationGrid(bf, 1, 1, 500, 0, 10,10, 1, 0, 0,  0, 80)];
%   grid.stimulusConstants.Agap = 1000;
%   grid.stimulusConstants.Bgap = 1000;
%   grid.stimulusConstants.tondur = 300;

  grid.stimulusConstants.Agap = 150;
  grid.stimulusConstants.Bgap = 150;
  grid.stimulusConstants.tondur = 50;
  grid.stimulusConstants.intdur =  0;
  grid.stimulusConstants.nprecycles = 3;
  grid.stimulusConstants.randomseed = [nan 5];
  grid.stimulusConstants.n = 1;

  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 10;
  
  % set this using absolute calibration
  % (same as quning)
  grid.stimLevelOffsetDB = [-104 -106];
  
  % compensation filter
  grid.initFunction = 'loadCompensationFilters';
  grid.compensationFilterFile = ...
    'e:\auditory-objects\calibration\calib.expt51\compensationFilters.100k.mat';
  %grid.compensationFilterFile = ...
  %  '../expt.42/calib.expt42/compensationFilters.mat';
  grid.compensationFilterVarNames = {'compensationFilters.L', 'compensationFilters.R'};
