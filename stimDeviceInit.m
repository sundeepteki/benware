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
    if stimDevice.GetSFreq~=sampleRatekHz
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
    if ~stimDevice.LoadCOFsf(rcxFilename,sampleRate)
        error(['Cannot load ' rcxFilename ]);
    end

    if ~stimDevice.Run
        error('Stimulus RCX Circuit failed to run.');
    end
end

fprintf([deviceName ' initialized, fs=' num2str(stimDevice.GetSFreq) '\n']);
