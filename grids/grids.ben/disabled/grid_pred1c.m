function grid = grid_pred1c()

  % controlling the sound presentation
  grid.sampleRate = tdt100k;
  grid.stimGenerationFunctionName = 'loadStereoFile';
  grid.stimDir = 'e:\auditory-objects\sounds-uncalib\pred1c\';
  grid.stimFilename = 'pred1c.type%1.set%2.n%3.wav';
  
  % stimulus grid structure
  grid.stimGridTitles = {'Type','Set','Number'};  
  stimGrid{1} = createPermutationGrid(1,1:14,1:10);
  stimGrid{2} = createPermutationGrid(0,1:9,1:10);
  stimGrid{3} = createPermutationGrid(3,1,1:14);
  stimGrid{4} = createPermutationGrid(4,1,1:14);
  stimGrid{5} = createPermutationGrid(6,1,1:14);
  stimGrid{6} = createPermutationGrid(3,2,1:14);
  stimGrid{7} = createPermutationGrid(4,2,1:14);
  stimGrid{8} = createPermutationGrid(6,2,1:14);
  
  %rng('shuffle')%was this
  rng('default')
  rateord = randperm(3);
  reord = [2 2+rateord 5+rateord 1];
  
  stimGrid = stimGrid(reord);
  sG = cat(1,stimGrid{:});
  grid.stimGrid = sG;
  
  
  
%   global CALIBRATE;
%   if CALIBRATE
%     fprintf('== Calibration mode. Press a key to continue == ')
%     pause;
%     grid.stimGrid = createPermutationGrid(1, 1); 
%   end
  
  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 1;
  grid.randomiseGrid = false;
  
  % set this to match nominal level of 80dB
%   grid.legacyLevelOffsetDB = 7;
  