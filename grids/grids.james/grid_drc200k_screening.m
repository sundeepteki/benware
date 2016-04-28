function grid = grid_drc200k_screening()

  % controlling the sound presentation
  grid.sampleRate = tdt200k;
  grid.stimGenerationFunctionName = 'stimgen_loadSoundFileWithLight';
  grid.stimDir = 'e:\auditory-objects\sounds-uncalib\mouse.drc.8\';
  grid.stimFilename = 'drc%1_dur%3_contrast%2.f32';
  
  % stimulus grid structure
  grid.stimGridTitles = {'DRC ID', 'Contrast', 'Chord dur', 'Light voltage'};  
  
  voltage = 5; % voltage to use for light
  grid.stimGrid = createPermutationGrid(1:4, 40, [25 50], [0 voltage]);

  global CALIBRATE
  if CALIBRATE
    % for calibration
    %grid.stimGrid = createPermutationGrid(9, 9);
    fprintf('For calibration only!\n');
    pause;
    grid.stimGrid = createPermutationGrid(1, [10], 25, 0); 
  end

  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 3;
  
  % set this to match nominal level of 80dB
  grid.legacyLevelOffsetDB = 0;
  