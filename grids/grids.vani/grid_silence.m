function grid = grid_silence

  % controlling the sound presentation
  grid.sampleRate = tdt100k;
  grid.stimGenerationFunctionName = 'makeCalibTone';

  % stimulus grid structure
  grid.stimGridTitles = {'Frequency', 'Duration', 'Level'};
  grid.stimGrid = [1000 40*1000 -100];

  % sweep parameters
  grid.postStimSilence = 0; %seconds
  
  % search mode
  grid.repeatsPerCondition = 30;
  