function grid = grid_puretone

  % essentials
  grid.name = 'puretone';

  % controlling the sound presentation
  grid.stimGenerationFunctionName = 'makeCalibTone';
  grid.sampleRate = 24414.0625*4;  % ~50kHz
  grid.monoStim = true;

  % stimulus grid structure
  grid.stimGridTitles = {'Frequency', 'Duration', 'Level'};
  grid.stimGrid = [6500 5000 80];
  
  % sweep parameters
  grid.postStimSilence = 0.05; %seconds
  
  % search mode
  grid.repeatsPerCondition = Inf;
  grid.saveWaveforms = true;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = -128+10;
