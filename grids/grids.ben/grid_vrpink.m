function grid = grid_vrpink()

  % controlling the sound presentation
  grid.sampleRate = tdt50k;
  grid.stimGenerationFunctionName = 'stimgen_loadSoundFile';
  grid.stimDir = 'e:\auditory-objects\sounds-uncalib\vrpink\';
  grid.stimFilename = 'vr_pink_p%1_%2ms.mat.wav';
  
  % stimulus grid structure
  grid.stimGridTitles = {'p', 'ms'};
  grid.stimGrid = [createPermutationGrid(1, [50 100 200]); ...
      createPermutationGrid(2, [66 100 200]); ...
      createPermutationGrid(3, 200)];

  global CALIBRATE;
  if CALIBRATE
   fprintf('Calibration only!!\n');
   pause;
   grid.stimGrid = [999 999]; % switching contrast, loud
  end
  
  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 5;
  
  % set this to match nominal level of 80dB
  grid.legacyLevelOffsetDB = 0;
  