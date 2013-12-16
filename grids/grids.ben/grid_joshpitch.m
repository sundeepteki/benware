function grid = grid_joshpitch()

  % controlling the sound presentation
  grid.sampleRate = 24414.0625*4;  % ~100kHz
  grid.stimGenerationFunctionName = 'loadStereoFile';
  grid.stimDir = 'e:\auditory-objects\sounds-uncalib\joshpitch\';
  grid.stimFilename = 'KerryPitchSounds2013_%1.wav';
  
  % stimulus grid structure
  grid.stimGridTitles = {'ID','dB'};  
  grid.stimGrid = [createPermutationGrid(1:15, 80); ... % 4 conditions, three tokens for basic characterisation. repeat twice
                    ];

  global CALIBRATE
  if CALIBRATE
    fprintf('Calibration only!!\n');
    pause;
    grid.stimGrid = [1 80];
  end
  
  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 1;
  
  % set this using absolute calibration
  grid.legacyLevelOffsetDB = 0;
  