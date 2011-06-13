function stimDeviceInit(deviceName, sampleRatekHz)

global stimDevice;

if sampleRatekHz>40000 && sampleRatekHz<=50000
    sampleRate = 3;
elseif sampleRatekHz>90000 && sampleRatekHz<=100000
    sampleRate = 4;
else
    error('Unknown sample rate');
end

if ~isempty(stimDevice)
    % check sample rate, clear device if wrong
    if stimDevice.GetSFreq==sampleRatekHz
        fprintf([deviceName ' already initialised at correct sample rate, doing nothing\n']);
    else
        fprintf('Wrong sample rate, clearing stimDevice\n');
        clear stimDevice;
        stimDevice = [];
    end
end

if isempty(stimDevice)
    fprintf(['Initialising ' deviceName '\n']);
    stimDevice=actxcontrol('RPco.x',[5 5 26 26]);
    if invoke(stimDevice,['Connect' deviceName],'GB',1) == 0
        error(['Cannot connect to ' deviceName ' on GB 1']);
    end

    rcxFilename = 'stereoPlay.rcx';
    if invoke(stimDevice,'LoadCOFsf',rcxFilename,sampleRate)==0
        error(['Cannot upload ' rcxFilename ]);
    end

    if invoke(stimDevice,'Run')==0
        error('Stimulus RCX Circuit failed to run.');
    end
end

fprintf([deviceName ' ready, fs=' num2str(stimDevice.GetSFreq) '\n']);
