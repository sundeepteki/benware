function grid = grid_monosearchnoise()

  % controlling the sound presentation
  grid.stimGenerationFunctionName = 'makeCSDprobe';
  grid.sampleRate = 24414.0625*4;  % ~100kHz

  % essentials
  grid.name = 'monosearchnoise';
  
  % stimulus grid structure
  grid.stimGridTitles = {'Stimulus Length (ms)', 'Delay (ms)'; 'Noise Length (ms)', 'Level'};
  grid.stimGrid = [200 50 50 80];

  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = Inf;
  grid.saveWaveforms = false;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = -92;
  
