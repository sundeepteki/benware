function grid = grid_sparseness_calib

% essentials
grid.name = 'sparseness.highlights';
grid.stimFilename = 'sparseness.set.%1.stimnum.%2.%L.f32';

% controlling the sound presentation
grid.stimGenerationFunctionName = 'loadStereo';
grid.stimDir = 'E:\auditory-objects\sounds.calib.expt%E\sparseness\';
grid.sampleRate = 24414.0625*2;  % ~50kHz

% stimulus grid structure
grid.stimGridTitles = {'StimID', 'Level'};
grid.stimGrid = [3 1 90];

% sweep parameters
grid.postStimSilence = .2; % seconds
grid.repeatsPerCondition = 100;

% set this using absolute calibration
grid.stimLevelOffsetDB = [-134 -129];
