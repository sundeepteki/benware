function grid = grid_reflec

% essentials
grid.name = 'reflec';
grid.stimGenerationFunctionName = 'loadStereo';
grid.stimDir = 'e:\auditory-objects\sounds.calib.expt%E\%N\';
grid.stimFilename = 'reflec.pos.%1.rtf.%2.%L.f32';
grid.sampleRate = 24414.0625*2;  % ~50kHz

% stimulus grid structure
grid.stimGridTitles = {'Position', 'RTF', 'Level'};

grid.stimGrid = [...
    createPermutationGrid(1, [12 21], 80); ...
    createPermutationGrid(2, [12 21], 80); ...
    createPermutationGrid([12 21], 1, 80); ...
    createPermutationGrid([12 21], 2, 80); ...
    ];

grid.repeatsPerCondition = 50;
grid.postStimSilence = 0.2;

% set this using absolute calibration
grid.stimLevelOffsetDB = [-100 -100];
    