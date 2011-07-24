function grid = grid_po_83dB()

  % controlling the sound presentation
  grid.stimGenerationFunctionName = 'loadStereo';
  grid.stimDir = 'E:\auditory-objects\sounds.calib.expt%E\po\';
  grid.sampleRate = 24414.0625*2;  % ~50kHz

  % essentials
  grid.name = 'po.83dB';
  grid.stimFilename = 'po.id.%1.token.%2.az1.%3.az2.%4.%L.f32';
  
  % stimulus grid structure
  grid.stimGridTitles = {'ID', 'Token', 'Azimuth1', 'Azimuth2', 'Level'};
  
  myGrid = combvec([435 436], 1:50, [-90 -45 -135 -180])';
  otherAz = -myGrid(:,3);
  otherAz(otherAz==180) = 0;
  grid.stimGrid = [myGrid otherAz];
  lev = 83 * ones(size(grid.stimGrid,1),1);
  grid.stimGrid(:,5)= lev;
  
  % sweep parameters
  grid.sweepLength = 0.22; % seconds
  grid.repeatsPerCondition = 1;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = [-128 -129.5];
