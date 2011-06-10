%% initial setup

global zBus stimDevice dataDevice;
global fs_in fs_out
global channelOrder

fs_in = 24414.0625;
fs_out = fs_in*2;

global truncate checkdata
truncate = true; % for testing only. should normally be FALSE
checkdata = false; % for testing only. should normally be FALSE

% don't forget this! channels need to be assigned correctly for rolling
% display and saving of data
%channelOrder = [9 8 10 7 13 4 12 5 15 2 16 1 14 3 11 6];
%channelOrder = [channelOrder channelOrder+16];

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

grid.name = 'ctuning.drc';
grid.stimGenerationFunctionName = 'loadStereo';
grid.stimDir = 'D:\auditory-objects\sounds.calib.expt%E\%N\';
grid.stimFilename = 'fw.%1.token.%2.naive.%L.f32';
grid.stimulusGridTitles = {'Full width','Token'};
grid.stimulusGrid = [30 1; 30 2; 30 3; 30 4; 30 5];
grid.stimGainMultiplier = 30;
grid.postStimSilence = 0.25;

grid.nStimConditions = size(grid.stimulusGrid,1);
grid.repeatsPerCondition = 10;
grid.dataDir = 'F:\expt-%E\%P-%N\';
grid.dataFilename = '%P.%N.sweep.%S.channel.%C.f32';

stimGenerationFunction = str2func(grid.stimGenerationFunctionName);

repeatedGrid = repmat(grid.stimulusGrid,[grid.repeatsPerCondition,1]);
grid.nSweepsDesired = size(repeatedGrid,1);
grid.randomisedGrid = repeatedGrid(randperm(grid.nSweepsDesired),:);

% upload first stimulus
tic;
[stim sweeps(1).stimInfo] = stimGenerationFunction(1,grid,expt);
uploadWholeStimulus(stim);

% run sweeps
for sweepNum = 1:grid.nSweepsDesired
    tic;
    fprintf(['== Starting sweep ' num2str(sweepNum) ' of ' num2str(grid.nSweepsDesired) '\n']);

    if sweepNum<grid.nSweepsDesired
        [nextStim,sweeps(sweepNum+1).stimInfo] = stimGenerationFunction(sweepNum+1,grid,expt);
    else
        nextStim = [];
    end
    
    sweepLen = size(stim,2)/fs_out+grid.postStimSilence; % length of CURRENT stimulus + a bit
    [data,sweeps(sweepNum).timeStamp] = runSweepFast(sweepLen,nextStim);    
    saveData(data,[grid.dataDir grid.dataFilename],grid,expt,sweepNum);

    fprintf(['== Finished sweep after ' num2str(toc) ' sec.\n\n']);
end
