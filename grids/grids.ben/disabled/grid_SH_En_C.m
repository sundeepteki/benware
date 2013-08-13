function grid = grid_sh_en_c

% essentials
grid.sampleRate = 24414.0625*2;  % ~50kHz
grid.stimGenerationFunctionName = 'loadStimAndCompensate';
grid.stimDir = 'e:\auditory-objects\sounds-uncalib\SH.En.C\';
grid.stimFilename = 'source.%1.sound.%2.snr.%3.token.%4.fw.%5.frozen.%6.f32';

% stimulus grid structure
grid.stimGridTitles = {'Source', 'Mode', 'BF', 'Token', 'Set', 'StimID', 'NominalLevel', 'Level'};

grid.stimGrid = [...
    createPermutationGrid(1, 0, 0, 0, 2, 1:12, 80, -49); % sparseness sounds, 4 times
    createPermutationGrid(1, 0, 0, 0, 2, 1:12, 80, -49);
    createPermutationGrid(1, 0, 0, 0, 2, 1:12, 80, -49);
    createPermutationGrid(1, 0, 0, 0, 2, 1:12, 80, -49);
    2   0   0   0   1   1  82 -48; % environmental sounds, 4 times
    2   0   0   0   1   2  80 -50;
    2   0   0   0   1   3  80 -50;
    2   0   0   0   1   4  80 -50;
    2   0   0   0   1   5  80 -50;
    2   0   0   0   1   6  80 -50;
    2   0   0   0   1   7  75 -55;
    2   0   0   0   1   8  80 -50;
    2   0   0   0   1   1  82 -48;
    2   0   0   0   1   2  80 -50;
    2   0   0   0   1   3  80 -50;
    2   0   0   0   1   4  80 -50;
    2   0   0   0   1   5  80 -50;
    2   0   0   0   1   6  80 -50;
    2   0   0   0   1   7  75 -55;
    2   0   0   0   1   8  80 -50;
    2   0   0   0   1   1  82 -48;
    2   0   0   0   1   2  80 -50;
    2   0   0   0   1   3  80 -50;
    2   0   0   0   1   4  80 -50;
    2   0   0   0   1   5  80 -50;
    2   0   0   0   1   6  80 -50;
    2   0   0   0   1   7  75 -55;
    2   0   0   0   1   8  80 -50;
    2   0   0   0   1   1  82 -48;
    2   0   0   0   1   2  80 -50;
    2   0   0   0   1   3  80 -50;
    2   0   0   0   1   4  80 -50;
    2   0   0   0   1   5  80 -50;
    2   0   0   0   1   6  80 -50;
    2   0   0   0   1   7  75 -55;
    2   0   0   0   1   8  80 -50;
    createPermutationGrid(9, 0, 0, 0:2, [10, 20, 30, 40], 0, 75, -13);]; % DRCs

%  fprintf('Calibration only!!\n');
%  grid.stimGrid = [createPermutationGrid(9, 0, 0, 0, 10, 0, 75, -13);];

grid.repeatsPerCondition = 5;
grid.postStimSilence = 0.2;

% set this using absolute calibration
grid.stimLevelOffsetDB = [16 16]+77;

% compensation filter
grid.initFunction = 'loadCompensationFilters';
grid.compensationFilterFile = ...
'e:\auditory-objects\calibration\calib.ben.2013.04.27\compensationFilters.mat';
grid.compensationFilterVarNames = {'compensationFilters.L', 'compensationFilters.R'};
