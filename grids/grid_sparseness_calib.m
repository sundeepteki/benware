function grid = grid_sparseness_calib

% controlling the sound presentation
grid.stimGenerationFunctionName = 'loadStereo';
grid.stimDir = 'D:\auditory-objects\sounds.calib.expt%E\sparseness\';
grid.sampleRate = 24414.0625*2;  % ~50kHz

% essentials
grid.name = 'sparseness.highlights';
grid.stimFilename = 'sparseness.set.3.stimnum.%1.%L.f32';

% stimulus grid structure
grid.stimGridTitles = {'StimID', 'Level'};
grid.stimGrid = [1 80];

% sweep parameters
grid.postStimSilence = .2; % seconds
grid.repeatsPerCondition = 30;

% set this using absolute calibration
grid.stimLevelOffsetDB = -50;
