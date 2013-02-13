function grid = mixmix

% essentials
grid.name = 'mixmix';
grid.stimGenerationFunctionName = 'loadStereo';
grid.stimDir = 'e:\auditory-objects\sounds.calib.expt51\%N\';
grid.stimFilename = 'source.%1.sound.%2.snr.%3.token.%4.fw.%5.frozen.%6.%L.f32';
grid.sampleRate = 24414.0625*2;  % ~50kHz

% stimulus grid structure
grid.stimGridTitles = {'Source', 'Mode', 'BF', 'Token', 'Set', 'StimID', 'NominalLevel', 'Level'};

grid.stimGrid = createPermutationGrid(3, 0, 0, 0, 1, 1:32, 80, -49);

grid.repeatsPerCondition = 20;
grid.postStimSilence = 0.2;

% set this using absolute calibration
grid.stimLevelOffsetDB = [10 10];
