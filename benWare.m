%% initial setup

addpath(genpath('D:\auditory-objects\NeilLib'))

global zBus stimDevice dataDevice;
global fs_in fs_out
global channelOrder

fs_in = 24414.0625;
fs_out = fs_in*2;

global truncate checkdata;
truncate = 1; % for testing only. should normally be 0
checkdata = false; % for testing only. should normally be FALSE

zBusInit;
stimulusDeviceInit('RX6',50);
dataDeviceInit;
pause(2);

% filename tokens:
% %E = expt number, e.g. '29'
% %1, %2... %9 = stimulus parameter value
% %N = grid name
% %L = left or right (for stimulus file)
% %P = penetration number
% %S = sweep number
% %C = channel number

expt.exptNum = 29;
expt.penetrationNum = 1;
expt.probe.lhs = 9999;
expt.probe.rhs = 9999;
expt.headstage.lhs = 9999;
expt.headstage.rhs = 9999;
channelMapping = [9 8 10 7 13 4 12 5 15 2 16 1 14 3 11 6];
expt.channelMapping = [channelMapping channelMapping+16];

grid.name = 'ctuning.drc';
grid.altName = '';
grid.stimGenerationFunctionName = 'loadStereo';
grid.stimDir = 'D:\auditory-objects\sounds.calib.expt%E\%N\';
grid.stimFilename = 'fw.%1.token.%2.naive.%L.f32';
grid.stimulusGridTitles = {'Full width','Token','Level'};
grid.stimulusGrid = [30 1 80; 30 2 70; 30 5 60];
grid.stimLevelOffsetDB = -50;
grid.postStimSilence = 0.25;

grid.nStimConditions = size(grid.stimulusGrid,1);
grid.repeatsPerCondition = 5;
grid.dataDir = 'F:\expt-%E\%P-%N\';
grid.dataFilename = 'raw.f32\%P.%N.sweep.%S.channel.%C.f32';

stimGenerationFunction = str2func(grid.stimGenerationFunctionName);

repeatedGrid = repmat(grid.stimulusGrid,[grid.repeatsPerCondition,1]);
grid.nSweepsDesired = size(repeatedGrid,1);
grid.randomisedGrid = repeatedGrid(randperm(grid.nSweepsDesired),:);

% check for existence of data directory. If it does exist, use grid.altName
% to store alternative name
grid.altName = verifySaveDir(grid,expt);
fprintf(['Saving to ' regexprep(constructDataPath(grid.dataDir(1:end-1),grid,expt),'\','\\\'),'\n']);

% save grid metadata
saveGridMetadata(grid,expt);

clear sweeps;

% upload first stimulus
tic;
[stim sweeps(1).stimInfo] = stimGenerationFunction(1,grid,expt);
uploadWholeStimulus(stim);

% run sweeps
for sweepNum = 1:grid.nSweepsDesired
    tic;
    fprintf('\n');
    fprintf(['== Starting sweep ' num2str(sweepNum) ' of ' num2str(grid.nSweepsDesired) '\n']);
    fprintf(['== Stimulus parameters: ' num2str(sweeps(sweepNum).stimInfo.stimParameters) '\n']);
    if sweepNum<grid.nSweepsDesired
        [nextStim,sweeps(sweepNum+1).stimInfo] = stimGenerationFunction(sweepNum+1,grid,expt);
    else
        nextStim = [];
    end
    
    sweepLen = size(stim,2)/fs_out+grid.postStimSilence; % length of CURRENT stimulus + a bit
    [data,sweeps(sweepNum).timeStamp] = runSweep(sweepLen,nextStim,expt.channelMapping);    
    saveData(data,grid,expt,sweepNum);
    saveSweepInfo(sweeps,grid,expt);

    fprintf(['== Finished sweep after ' num2str(toc) ' sec.\n\n']);
end
