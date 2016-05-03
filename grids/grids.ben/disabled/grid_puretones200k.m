function grid = grid_puretones200k()

  % essentials
  grid.name = 'puretones';
  %grid.stimFilename = 'quning.cf.%1.%L.f32';

  % controlling the sound presentation
  grid.stimGenerationFunctionName = 'makeCalibTone';
  %grid.stimDir = 'E:\auditory-objects\sounds.calib.expt%E\%N\';
  grid.sampleRate = 24414.0625*4;  % ~200kHz

  
  % stimulus grid structure
  grid.stimGridTitles = {'Frequency', 'Delay (ms)', 'Duration (ms), 'Level (dB)'};

  % frequencies and levels
  freq_min = 4000;
  freq_max = 64000;
  freqs = logspace(log10(freq_min), log10(freq_max), 17);
 
  levels = 40:10:100;
  
  grid.stimGrid = createPermutationGrid(freqs, 0, 50, levels);

  % sweep parameters
  grid.sweepLength = 100;
  grid.repeatsPerCondition = 10;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = -90;
  
  
