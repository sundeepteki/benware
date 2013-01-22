function [device, sampleRate] = ...
  dataDeviceInit(device, deviceName, requestedSampleRateHz,  ...
  channelMapping, stimDevice)
% [device, sampleRate] = ...
%   dataDeviceInit(device, deviceName, requestedSampleRate, channelMapping)
% 
% Initialise TDT data device and set the channel mapping
% 
% device: Existing handle to the device, or [] if you don't have one
% deviceName: e.g. 'RZ5'
% requestedSampleRateHz: desired sample rate, e.g. 48828.125
% channelMapping: A vector specifying the order you want the channels in
% stimDevice: Handle to stim device if available (used for fake device only)

global fakeHardware

if fakeHardware

  if isempty(device) || ~deviceIsFake(device)
    device = fakeDataDevice(deviceName, requestedSampleRateHz, stimDevice);
    sampleRate = device.sampleRate;
    fprintf('  * Initialising fake data device\n');

  else
    sampleRate = device.sampleRate;
    fprintf('  * Fake data device already connected, doing nothing\n');
  end

else

  if deviceIsFake(device)
    device = [];
  end
  
  [device, sampleRate] = deviceInit(device, deviceName, ...
    ['benware/tdt/' deviceName '-nogain-humbucker.rcx'], ...
    [deviceName 'NoGainVer'], 3, requestedSampleRateHz);

end

% NB! This mapping has to be uploaded to TDT as 32-bit integers
device.WriteTagVEX('ChanMap',0,'I32',channelMapping);
