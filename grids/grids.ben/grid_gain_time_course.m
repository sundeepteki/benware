function grid = grid_gain_time_course()

  % controlling the sound presentation
  grid.stimGenerationFunctionName = 'stimgen_loadSoundFile';
  grid.stimDir = 'E:\auditory-objects\sounds.calib.expt%E\%N\';
  grid.sampleRate = 24414.0625*2;  % ~50kHz

  % essentials
  grid.name = 'gain_time_course';
  grid.stimFilename = 'gain_time_course.chord_fs.%1.token.%2.%L.f32';
  
  % stimulus grid structure
  grid.stimGridTitles = {'Chord_Fs', 'Token'};
  
  grid.stimGrid = [...
      10,0;
      10,1;
      10,2;
      10,3;
      20,0;
      20,1;
      40,0;
      80,0;
      160,0]; % csdprobe stimulus 

  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 7;
  
  % set this using absolute calibration
  grid.legacyLevelOffsetDB = [-82, -82];
  
