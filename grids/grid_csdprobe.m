function grid = grid_csdprobe()

  % controlling the sound presentation
  grid.stimGenerationFunctionName = 'makeCSDprobe';
  grid.sampleRate = 24414.0625*2;  % ~100kHz

  % essentials
  grid.name = 'csdprobe';
  
  % stimulus grid structure
  grid.stimGridTitles = {'Stimulus Length (ms)', 'Delay (ms)'; 'Noise Length (ms)', 'Level'};
  grid.stimGrid = [490 50 10 80];

  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = Inf;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = -112;
  
