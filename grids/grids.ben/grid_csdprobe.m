function grid = grid_csdprobe()

  % controlling the sound presentation
  grid.sampleRate = 24414.0625*4;  % ~100kHz
  grid.stimGenerationFunctionName = 'makeCSDprobe';
  
  % stimulus grid structure
  grid.stimGridTitles = {'Stimulus Length (ms)', 'Delay (ms)'; 'Noise Length (ms)', 'Level'};
  grid.stimGrid = [490 50 50 80];

  global CALIBRATE;
  if CALIBRATE
   fprintf('For calibration only!\n');
   pause;
   grid.stimGrid = [490 50 480 80];
  end
  
  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = Inf;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = -46;
  
