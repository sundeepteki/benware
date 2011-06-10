function stimulusDeviceInit(deviceName,sampleRatekHz)

global stimDevice;

if isempty(stimDevice)
    fprintf(['Initialising ' deviceName '\n']);
    stimDevice=actxcontrol('RPco.x',[5 5 26 26]);
    if invoke(stimDevice,['Connect' deviceName],'GB',1) == 0
        error(['Cannot connect to ' deviceName ' on GB 1']);
    end

    rcxFilename = ['stereoPlay' num2str(sampleRatekHz) 'k.rcx'];
    if invoke(stimDevice,'LoadCOF',rcxFilename) == 0
        error(['Cannot load ' rcxFilename ]);
    end

    if invoke(stimDevice,'Run') == 0
        error('Stimulus RCX Circuit failed to run.');
    end
end

