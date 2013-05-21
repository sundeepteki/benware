function grid = grid_monosearchnoise()

  % controlling the sound presentation
  grid.sampleRate = 24414.0625*8;  % ~100kHz
  grid.stimGenerationFunctionName = 'makeCSDprobe';
  
  % stimulus grid structure
  grid.stimGridTitles = {'Stimulus Length (ms)', 'Delay (ms)'; 'Noise Length (ms)', 'Level'};
  grid.stimGrid = [250 50 50 80];

  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = Inf;
  grid.saveWaveforms = false;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = [-21+0 0];
  
