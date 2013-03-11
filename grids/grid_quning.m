function grid = grid_quning()

  % controlling the sound presentation
  grid.sampleRate = 24414.0625*4;  % ~100kHz
  grid.stimGenerationFunctionName = 'makeCalibTone';
  %grid.stimDir = 'E:\auditory-objects\sounds.calib.expt%E\%N\';
  %grid.stimFilename = 'quning.cf.%1.%L.f32';
  
  % stimulus grid structure
  grid.stimGridTitles = {'Frequency', 'Duration', 'Level'};

  % frequencies and levels
%   freqs = [500, 550, 650, 700, 800, 900, 1000, 1100, 1250, 1400, 1600, 1800, ...
%    2000, 2250, 2850, 3150, 3550, 4000, 4500, 5050, 5650, 6350, 7150, 8000, ...
%    9000, 10100, 11300, 12700, 14250, 16000, 17950, 20150, 22650];
  freqs = logspace(log10(500), log10(500*2^5.75), 5.75*4+1);  
  levels = 50:20:90;
  tonedur = 50;
%   
%   fprintf('Calibration only!\n');
%   freqs = [500 1000 10000 25000];
%   levels = 80;
%   tonedur = 1000;

  grid.stimGrid = createPermutationGrid(freqs, tonedur, levels);

  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 30;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = [-104, -106];
  
  
  % compensation filter
  grid.initFunction = 'loadCompensationFilters';
  grid.compensationFilterFile = ...
    'e:\auditory-objects\calibration\calib.expt51\compensationFilters.100k.mat';
  grid.compensationFilterVarNames = {'compensationFilters.L', 'compensationFilters.R'};
