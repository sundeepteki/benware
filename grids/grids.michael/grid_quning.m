function grid = grid_quning()

compfilt=0
  % controlling the sound presentation
  grid.sampleRate = 24414.0625*8;  % ~100kHz
  grid.stimGenerationFunctionName = 'makeCalibTone';
  
  % stimulus grid structure
  grid.stimGridTitles = {'Frequency', 'Duration', 'Level'};

  % frequencies and levels
  freqs = logspace(log10(500), log10(500*2^7), 7*2+1) % maybe spread it between 1000-64000hz insteda of from 500hs. Also if you do that, maybe you can reduce amount of tones to maybe 13-14 tones;  
  levels = 70:20:90;
  tonedur = 100;

  global CALIBRATE;
  if CALIBRATE
    fprintf('== Calibration mode. Press a key to continue == ')
    pause;
    freqs = [1000];
    levels = 80;
    tonedur = 1000;
  end

  grid.stimGrid = createPermutationGrid(freqs, tonedur, levels);

  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 20;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = [0 0]-16-35+25+10;
  
  if compfilt == 1
  % compensation filters
  grid.initFunction = 'loadCompensationFilters';
  grid.compensationFilterFile = ...
    'e:\auditory-objects\calibration\calib.2014.01.06\compensationFilters.100k.mat'; % 100kHz
  grid.compensationFilterVarNames = {'compensationFilters.L', 'compensationFilters.R'};
  end
