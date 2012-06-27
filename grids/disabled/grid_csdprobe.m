function grid = grid_csdprobe()

  % controlling the sound presentation
  grid.stimGenerationFunctionName = 'loadStereo';
  grid.stimDir = 'E:\auditory-objects\sounds.calib.expt%E\gain_time_course\';
  grid.sampleRate = 24414.0625*2;  % ~50kHz

  % essentials
  grid.name = 'csdprobe';
  grid.stimFilename = 'gain_time_course.chord_fs.%1.token.%2.%L.f32';
  
  % stimulus grid structure
  grid.stimGridTitles = {'Chord_Fs', 'Token', 'Level'};
  
  grid.stimGrid = [0,490,53]; % csdprobe stimulus 

  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 40;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = [-82, -82];
  
