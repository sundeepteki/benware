function grid = grid_monosearchnoise()

  % controlling the sound presentation
  grid.stimGenerationFunctionName = 'makeCSDprobeWithLight';
  grid.sampleRate = 24414.0625*8;  % ~100kHz

  % essentials
  grid.name = 'noise_with_light';
  
  % stimulus grid structure
  grid.stimGridTitles = {'Stimulus Length (ms)', 'Noise Delay (ms)', 'Noise Length (ms)', 'Light voltage (V)', 'Light delay (ms)', 'Light Duration (ms)', 'Level'};
  grid.stimGrid = [200 50 50 0 50 150 80; 200 50 50 5 50 150 80];

  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 20;
  grid.saveWaveforms = false;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = -92;
  
