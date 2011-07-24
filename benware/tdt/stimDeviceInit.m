function [device, sampleRate] = ...
  stimDeviceInit(device, deviceName, requestedSampleRate)
% [device, sampleRate] = ...
%   stimDeviceInit(device, deviceName, requestedSampleRate)
% 
% Initialise TDT stimulus device
% 
% device: Existing handle to the device, or [] if you don't have one
% deviceName: e.g. 'RX6'
% requestedSampleRate: desired sample rate, e.g. 48828.125

global fakeHardware

if fakeHardware

  if isempty(device) || ~deviceIsFake(device)
    device = fakeStimDevice(deviceName, requestedSampleRate);
    sampleRate = device.sampleRate;
    fprintf('  * Initialising fake stimulus device\n');

  else
    sampleRate = device.sampleRate;
    fprintf('  * Fake stimulus device already connected, doing nothing\n');
  end

else

  if deviceIsFake(device)
    device = [];
  end

  [device, sampleRate] = deviceInit(device, deviceName, ...
    'benware/tdt/stereoplay.rcx', 'StereoPlayVer', 3, requestedSampleRate);

end