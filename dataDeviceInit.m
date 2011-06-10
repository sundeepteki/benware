function dataDeviceInit

deviceName = 'RZ5';

global dataDevice;

if isempty(dataDevice)
    fprintf(['Initialising ' deviceName '\n']);
    dataDevice=actxcontrol('RPco.x',[5 5 26 26]);
    if invoke(dataDevice,['Connect' deviceName],'GB',1) == 0
        error(['Cannot connect to ' deviceName ' on GB 1']);
    end;

    rcxFilename = 'RZ5-gain.rcx';
    if invoke(dataDevice,'LoadCOF',rcxFilename) == 0
        error(['Cannot load ' rcxFilename ]);
    end;

    if invoke(dataDevice,'Run') == 0
        error('Data RCX Circuit failed to run.');
    end;
end
