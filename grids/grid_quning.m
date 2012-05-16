function grid = grid_quning()

  % essentials
  grid.name = 'quning';
  grid.stimFilename = 'quning.cf.%1.%L.f32';

  % controlling the sound presentation
  grid.stimGenerationFunctionName = 'loadStereo';
  grid.stimDir = 'E:\auditory-objects\sounds.calib.expt%E\%N\';
  grid.sampleRate = 24414.0625*2;  % ~50kHz

  
  % stimulus grid structure
  grid.stimGridTitles = {'Frequency', 'Level'};

  % frequencies and levels
  freqs = [500, 550, 650, 700, 800, 900, 1000, 1100, 1250, 1400, 1600, 1800, ...
   2000, 2250, 2850, 3150, 3550, 4000, 4500, 5050, 5650, 6350, 7150, 8000, ...
   9000, 10100, 11300, 12700, 14250, 16000, 17950, 20150, 22650];
 
  levels = 40:10:100;

  grid.stimGrid = createPermutationGrid(freqs, levels);

  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 10;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = [-80, -80];
  
  
