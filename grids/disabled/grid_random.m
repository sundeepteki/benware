function grid = grid_random

  % essentials
  grid.name = 'random';

  % controlling the sound presentation
  grid.stimGenerationFunctionName = 'randomStim';
  grid.sampleRate = 24414.0625*2;  % ~50kHz

  % stimulus grid structure
  grid.stimGridTitles = {'Duration', 'Level'};
  grid.stimGrid = [200 80; 300 80; 100 80; 100 80; 50 80];
  
  % sweep parameters
  %grid.postStimSilence = 0.2; %seconds
  grid.sweepLen = .1;
  
  % search mode
  grid.repeatsPerCondition = 10;
  grid.saveWaveforms = false;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = -128;
