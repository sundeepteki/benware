function grid = grid_decorr_v2()

  % controlling the sound presentation
  grid.sampleRate = tdt100k;
  grid.stimGenerationFunctionName = 'loadStereoFile';
  grid.stimDir = 'e:\auditory-objects\sounds-uncalib\decorr.v2\';
  grid.stimFilename = 'drc.cond.%1.token.%2.f32';
  
  % stimulus grid structure
  grid.stimGridTitles = {'Condition', 'Token'};  
  grid.stimGrid = [createPermutationGrid(1:12, 1:2)];

  global CALIBRATE;
  if CALIBRATE
   fprintf('Calibration only!!\n');
   pause;
   grid.stimGrid = [4 1]; % switching contrast, loud
  end

  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 4;
  
  % set this to match nominal level of 80dB
  grid.legacyLevelOffsetDB = -10;
  