function dataDeviceInit
% This function should allow other device choices than RZ5,
% (though this would require different RCX files too
% It should also check whether the dataDevice is actually
% running the requested RCX file, and at the correct sample rate.

deviceName = 'RZ5';

global dataDevice;

if isempty(dataDevice)
    fprintf(['Initialising ' deviceName '\n']);
    dataDevice=actxcontrol('RPco.x',[1 1 2 2]);
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
else
    fprintf('RX6 alrady initialised, doing nothing\n');
end
