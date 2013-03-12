function grid = grid_puretonestest()

  % essentials
  %grid.stimFilename = 'quning.cf.%1.%L.f32';

  % controlling the sound presentation
  grid.stimGenerationFunctionName = 'makeCalibTone';
  %grid.stimDir = 'E:\auditory-objects\sounds.calib.expt%E\%N\';
  grid.sampleRate = 24414.0625*8;  % ~200kHz

  % compensation filter
  grid.initFunction = 'loadCompensationFilters';
  grid.compensationFilterFile = ...
    '/Users/ben/scratch/james-01/calibL_200k.mat';
  grid.compensationFilterVarNames = {'calibL_200k.filter'};  
  
  % stimulus grid structure
  grid.stimGridTitles = {'Frequency', 'Duration (ms)', 'Level (dB)'};

  % frequencies and levels
  freq_min = 4000;
  freq_max = 64000*2^(.5);
  freq_step_oct = 1/4;
  n_steps = floor(log2(freq_max/freq_min)/freq_step_oct);
  freqs = logspace(log10(freq_min), log10(freq_max), n_steps+1)
 
  levels = 40:10:100;
  
  grid.stimGrid = createPermutationGrid(freqs, 50, levels);

  % sweep parameters
  grid.sweepLength = 0.1;
  grid.repeatsPerCondition = 10;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = -80;
  
  
