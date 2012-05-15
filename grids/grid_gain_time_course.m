function grid = grid_gain_time_course()

  % controlling the sound presentation
  grid.stimGenerationFunctionName = 'loadStereo';
  grid.stimDir = 'E:\auditory-objects\sounds.calib.expt%E\%N\';
  grid.sampleRate = 24414.0625*2;  % ~50kHz

  % essentials
  grid.name = 'gain_time_course';
  grid.stimFilename = 'gain_time_course.chord_fs.%1.token.%2.%L.f32';
  
  % stimulus grid structure
  grid.stimGridTitles = {'Chord_Fs', 'Token', 'Level'};

  grid.stimGrid = [...
      10,0,70;
      10,1,70;
      10,2,70;
      10,3,70;
      20,0,70;
      20,1,70;
      40,0,70;
      80,0,70;
      160,0,70];
  
  %	  0,490,53]; csdprobe stimulus -- needs to be created

  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 7;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = [-82, -82];
  
