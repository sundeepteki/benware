function grid = grid_noise

  % essentials
  grid.name = 'noise';

  % controlling the sound presentation
  grid.stimGenerationFunctionName = 'makeNoiseBurst';
  grid.sampleRate = 24414.0625*4;  % ~50kHz
  grid.monoStim = true;

  % stimulus grid structure
  grid.stimGridTitles = {'Duration', 'Level'};
  grid.stimGrid = [50 75];
  
  % sweep parameters
  grid.postStimSilence = 0.05; %seconds
  
  % search mode
  grid.repeatsPerCondition = Inf;
  grid.saveWaveforms = true;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = -88;
