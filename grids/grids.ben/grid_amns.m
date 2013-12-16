function grid = grid_amns()

  % controlling the sound presentation
  grid.sampleRate = 24414.0625*2;  % ~50kHz
  grid.stimGenerationFunctionName = 'loadStereoFile';
  grid.stimDir = 'e:\auditory-objects\sounds-uncalib\AMNs\';
  grid.stimFilename = 'AMN.%1_%2.wav';
  
  % stimulus grid structure
  grid.stimGridTitles = {'id1', 'id2', 'Level'};  
  grid.stimGrid = [createPermutationGrid(1:2, 1:6, 80)];

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
  