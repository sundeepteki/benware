function grid = grid_bilateral_noise

  % controlling the sound presentation
  grid.sampleRate = tdt100k;
  grid.stimGenerationFunctionName = 'makeBilateralNoise';

  % stimulus grid structure
  grid.stimGridTitles = {'Duration', 'LeftDelay', 'RightDelay', 'BothDelay', 'Level'};
  grid.stimGrid = [45 0 100 200 80];
  
  global CALIBRATION
  if CALIBRATION
    fprintf('== Calibration only!\n');
    pause;
    grid.stimGrid = [500 0 1000 2000 80];  
  end
  
  % sweep parameters
  grid.postStimSilence = 0.2; %seconds
  
  % search mode
  grid.repeatsPerCondition = Inf;
  grid.saveWaveforms = false;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = [-116 -116]+75;
