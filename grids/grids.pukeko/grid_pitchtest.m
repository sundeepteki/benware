function grid = grid_pitchtest()

  % controlling the sound presentation
  grid.sampleRate = 24414.0625*4;
  grid.stimGenerationFunctionName = 'stimgen_loadSoundFile'; 
  grid.stimDir = 'C:\benware-new\benware\sounds\';
  grid.stimFilename = 'QuentinPitchSounds2016_%1.wav';
  
  % stimulus grid structure
  grid.stimGridTitles = {'ID'};  
  grid.stimGrid = createPermutationGrid(1:15);

  global CALIBRATE
  if CALIBRATE
    fprintf('Calibration only!!\n');
    pause;
    grid.stimGrid = [1];
  end
  
  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 1;
  
  % set this to match nominal level of 80dB
  grid.legacyLevelOffsetDB = 12.5;
  