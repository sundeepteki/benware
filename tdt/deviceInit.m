function [device, sampleRateHz] = deviceInit(device, deviceName, rcxFilename, versionTagName, versionTagValue, requestedSampleRateHz)
% stimDeviceInit(deviceName, sampleRateHz)

if requestedSampleRateHz>20000 && requestedSampleRateHz<=25000
  sampleRate = 2;
  sampleRateHz = 48828.125/2;
elseif requestedSampleRateHz>40000 && requestedSampleRateHz<=50000
  sampleRate = 3;
  sampleRateHz = 48828.125;
elseif requestedSampleRateHz>90000 && requestedSampleRateHz<=100000
  sampleRate = 4;
  sampleRateHz = 48828.125*2;
else
  error('Unknown sample rate');
end

% check whether we already have a handle to a correctly set up device
% if not, clear it

if ~isempty(device)
  
  [ok, message] = checkDevice(device, sampleRateHz, versionTagName, versionTagValue);
  
  if ok
    fprintf(['  * ' deviceName ' is already initialised, doing nothing\n']);
    return;
  else
    fprintf(['  * ' deviceName ' needs reinitialisation (' message ')\n']);
  end
  
end

fprintf(['  * Initialising ' deviceName '\n']);
device=actxcontrol('RPco.x', [5 5 26 26]);
if invoke(device, ['Connect' deviceName], 'GB', 1) == 0
  error(['Cannot connect to ' deviceName ' on GB 1']);
end

if invoke(device, 'LoadCOFsf', rcxFilename, sampleRate) == 0
  error(['Cannot upload ' rcxFilename ]);
end

if invoke(device, 'Run') == 0
  error('Stimulus RCX Circuit failed to run.');
end

[ok, message] = checkDevice(device, sampleRateHz, versionTagName, versionTagValue);

if ok
  fprintf(['  * ' deviceName ' ready, sample rate = ' num2str(device.GetSFreq) ' Hz\n']);
else
  error(['Couldn''t initialise ' deviceName ': ' message]);
end
