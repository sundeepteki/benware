function grid = grid_amnoise()

  % controlling the sound presentation
  grid.sampleRate = tdt100k;
  grid.stimGenerationFunctionName = 'loadStereoFile';
  grid.stimDir = 'e:\auditory-objects\sounds-uncalib\amnoise\';
  grid.stimFilename = 'amnoise.%1.hz.f32';

  % stimulus grid structure
  grid.stimGridTitles = {'ModulationFrequency'};
  modFreqs = [.5 1:10];
  grid.stimGrid = [createPermutationGrid(modFreqs);
                    ];

  global CALIBRATE;
  if CALIBRATE
   fprintf('Calibration only!!\n');
   pause;
   grid.stimGrid = [0 1];
  end

  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 10;

  % set this to match nominal level of 80dB
  %grid.legacyLevelOffsetDB = 9;
