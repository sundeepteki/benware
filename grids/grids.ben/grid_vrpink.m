function grid = grid_vrpink()

  % controlling the sound presentation
  grid.sampleRate = 24414.0625*2;  % ~100kHz
  grid.stimGenerationFunctionName = 'loadStereoFile';
  grid.stimDir = 'e:\auditory-objects\sounds-uncalib\vrpink\';
  grid.stimFilename = 'vr_pink_p%1_%2ms.mat.wav';
  
  % stimulus grid structure
  grid.stimGridTitles = {'p', 'ms', 'Level'};  
  grid.stimGrid = [createPermutationGrid(1, [50 100 200], 80); ...
      createPermutationGrid(2, [66 100 200], 80); ...
      createPermutationGrid(3, 200, 80)];

  global CALIBRATE;
  if CALIBRATE
   fprintf('Calibration only!!\n');
   pause;
   grid.stimGrid = [999 999 80]; % switching contrast, loud
  end
  
  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 5;
  
  % set this using absolute calibration
  grid.legacyLevelOffsetDB = 0;
  