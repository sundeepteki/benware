function grid = grid_amns()

  % controlling the sound presentation
  grid.sampleRate = tdt50k;
  grid.stimGenerationFunctionName = 'loadStereoFile';
  grid.stimDir = 'e:\auditory-objects\sounds-uncalib\AMNs\';
  grid.stimFilename = 'AMN.%1_%2.wav';
  
  % stimulus grid structure
  grid.stimGridTitles = {'id1', 'id2'};  
  grid.stimGrid = [createPermutationGrid(1:2, 1:6)]; % 80dB

  global CALIBRATE;
  if CALIBRATE
   fprintf('Calibration only!!\n');
   pause;
   grid.stimGrid = [999 999];
  end
  
  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 5;
  
  % set this to match nominal level of 80dB
  grid.legacyLevelOffsetDB = 0;
  