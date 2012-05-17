function grid = grid_reflec_v2

% essentials
grid.name = 'reflec.v2';
grid.stimGenerationFunctionName = 'loadStereo';
grid.stimDir = 'e:\auditory-objects\sounds.calib.expt%E\%N\';
grid.stimFilename = 'reflec.pos.%1.rtf.%2.rev.%3.%L.f32';
grid.sampleRate = 24414.0625*2;  % ~50kHz

% stimulus grid structure
grid.stimGridTitles = {'Position', 'RTF', 'Reversal', 'Level'};

grid.stimGrid = [...
    createPermutationGrid(1, [11 12 21 22], [1 2], 80); ...
    createPermutationGrid(2, [11 12 21 22], [1 2], 80); ...
    createPermutationGrid([11 12 21 22], 1, [1 2], 80); ...
    createPermutationGrid([11 12 21 22], 2, [1 2], 80); ...
    ];

grid.repeatsPerCondition = 20;
grid.postStimSilence = 0.2;

% set this using absolute calibration
grid.stimLevelOffsetDB = [-100 -100];
    