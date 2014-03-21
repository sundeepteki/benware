function grid = grid_amns()

  % controlling the sound presentation
  grid.sampleRate = tdt50k;
  grid.stimGenerationFunctionName = 'loadStereoFile';
  grid.stimDir = 'e:\James\Stimuli\AMNsv3log\';
  grid.stimFilename = 'AMNv3_%1_%2_%3.f32';
  
  % stimulus grid structure
  grid.stimGridTitles = {'rate1', 'rate2', 'contrast2'};  
  vals = floor(logspace(log10(4), log10(40), 8));
  grid.stimGrid = [createAMNPermutationGrid(vals, vals, [25 50 75 100])]; % 80dB

  global CALIBRATE;
  if CALIBRATE
   fprintf('Calibration only!!\n');
   pause;
   grid.stimGrid = [999 999 999];
  end
  
  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 15;
  
  % set this to match nominal level of 80dB
  % grid.legacyLevelOffsetDB = 0;
  