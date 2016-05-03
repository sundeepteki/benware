function grid = grid_josh_natural

% essentials
grid.stimGenerationFunctionName = 'loadStereo';
grid.stimDir = 'e:\auditory-objects\sounds.calib.expt42\josh.natural\';
grid.stimFilename = 'NatSoundsJosh_chunk%1_ex%2.%L.f32';
grid.sampleRate = 24414.0625*2;  % ~50kHz

% stimulus grid structure
grid.stimGridTitles = {'Chunk', 'Example', 'Level'};

grid.stimGrid = createPermutationGrid(1:5, 1:2, 80);

%fprintf('** calibration only **\n');
%grid.stimGrid = createPermutationGrid(9,9, 80);

grid.repeatsPerCondition = 10;
grid.postStimSilence = 0.2;

% set this using absolute calibration
grid.stimLevelOffsetDB = [-72 -72];
