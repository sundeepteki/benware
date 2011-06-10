%% initial setup

global zBus stimDevice dataDevice;
global fs_in fs_out
global channelOrder

fs_in = 24414.0625;
fs_out = fs_in*2;

% don't forget this! channels need to be assigned correctly for rolling
% display and saving of data
%channelOrder = [9 8 10 7 13 4 12 5 15 2 16 1 14 3 11 6];
%channelOrder = [channelOrder channelOrder+16];

zBusInit;
stimulusDeviceInit('RX6',50);
dataDeviceInit;
pause(2);

dataGain = 1;
extraTimePerSweep = 0.25;

grid.filename = 'D:\auditory-objects\sounds.calib.expt29\ctuning.drc\fw.30.token.%N.naive.%L.f32';
grid.nStimuli = 5;
grid.stimMultiplier = 30;
grid.repeats = 10;
grid.savename = 'f:\junkdata\%P\ctuning.drc.s%S.c%C.f32';

penNum = 1;

stimNum = repmat(1:grid.nStimuli,[1 grid.repeats]);
stimNum = stimNum(randperm(length(stimNum)));

sweepNum = 0;
for ii = 1:length(stimNum)
    sweepNum = sweepNum + 1;

    fprintf(['== Starting sweep ' num2str(sweepNum) ' of ' num2str(length(stimNum)) '\n']);

    tic;
    f = findstr('%N',grid.filename);
    filename = [grid.filename(1:f-1) num2str(stimNum(ii)) grid.filename(f+2:end)];
    f = findstr('%L',filename);
    stimfileL = [filename(1:f-1) 'L' filename(f+2:end)];
    stimfileR = [filename(1:f-1) 'R' filename(f+2:end)];
    
    stimMultiplier = 30;
    stim = loadStimulus(stimfileL,stimfileR,stimMultiplier);
    stim = stim(:,1:round(5*fs_out)); % hack to present 1 second stimulus instead of 30
    sweepLen = size(stim,2)/fs_out+extraTimePerSweep;

    data = runSweep(sweepLen,stim,dataGain);
    
    saveData(data,grid.savename,penNum,sweepNum);
    fprintf(['== Finished sweep after ' num2str(toc) ' sec.\n\n']);
end
