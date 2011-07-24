function grid = grid_sparseness_highlights

  % essentials
  grid.name = 'sparseness.highlights';
  grid.stimFilename = 'sparseness.set.%1.stimnum.%2.%L.f32';

  % controlling the sound presentation
  grid.stimGenerationFunctionName = 'loadStereo';
  grid.stimDir = 'E:\auditory-objects\sounds.calib.expt%E\sparseness\';
  grid.sampleRate = 24414.0625*2;  % ~50kHz

  % stimulus grid structure
  grid.stimGridTitles = {'Set', 'StimID', 'Level'};
  grid.stimGrid = createPermutationGrid(2,1:12, 80);
  
  % sweep parameters
  grid.postStimSilence = 0.2; %seconds
  grid.repeatsPerCondition = 30;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = [-134 -129];
