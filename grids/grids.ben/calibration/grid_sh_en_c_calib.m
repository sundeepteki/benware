function grid = grid_sh_en_c_calib

% essentials
grid.name = 'SH.En.C';
grid.stimGenerationFunctionName = 'loadStereo';
grid.stimDir = 'e:\auditory-objects\sounds.calib.expt%E\%N\';
grid.stimFilename = 'source.%1.sound.%2.snr.%3.token.%4.fw.%5.frozen.%6.%L.f32';
grid.sampleRate = 24414.0625*2;  % ~50kHz

% stimulus grid structure
grid.stimGridTitles = {'Source', 'Sound', 'SNR', 'Token', 'Fullwidth', 'Frozen', 'NominalLevel', 'Level'};

grid.stimGrid = [9, 0, 0, 1, 10, 0, 85, -13]; % DRCs

grid.repeatsPerCondition = 5;
grid.postStimSilence = 0;

% set this using absolute calibration
grid.stimLevelOffsetDB = [25 26];
