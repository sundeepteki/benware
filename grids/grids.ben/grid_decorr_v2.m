function grid = grid_decorr_v2()

  % controlling the sound presentation
  grid.sampleRate = tdt100k;
  grid.stimGenerationFunctionName = 'loadStereoFile';
  grid.stimDir = 'e:\auditory-objects\sounds-uncalib\decorr.v2\';
  grid.stimFilename = 'drc.cond.%1.token.%2.f32';
  
  % stimulus grid structure
  grid.stimGridTitles = {'Condition', 'Token', 'Level'};  
  grid.stimGrid = [createPermutationGrid(1:12, 1:2, 80)];

  global CALIBRATE;
  if CALIBRATE
   fprintf('Calibration only!!\n');
   pause;
   grid.stimGrid = [4 1 80]; % switching contrast, loud
  end

  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 4;
  
  % level adjustment for old stimuli
  grid.legacyLevelOffsetDB = 0;
  