function grid = grid_chait()

  % controlling the sound presentation
  grid.sampleRate = tdt100k;
  grid.stimGenerationFunctionName = 'loadStereoFile';
  grid.stimDir = 'e:\auditory-objects\sounds-uncalib\chait.drc.1\';
  grid.stimFilename = 'drc.token.%1.rep.%2.f32';
  
  % stimulus grid structure
  grid.stimGridTitles = {'Token', 'Repeating'};  
  grid.stimGrid = [createPermutationGrid(1:4, 0:1)];

  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 20;