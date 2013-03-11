function [device, sampleRate] = ...
  stimDeviceInit(device, deviceName, requestedSampleRate, mono)
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
  
  if mono
    [device, sampleRate] = deviceInit(device, deviceName, ...
      'benware/tdt/monoplay.rcx', 'MonoPlayVer', 3, requestedSampleRate);
  else
    [device, sampleRate] = deviceInit(device, deviceName, ...
      'benware/tdt/stereoplay.rcx', 'StereoPlayVer', 5, requestedSampleRate);
  end
  
  if strcmp(deviceName, 'RX8')
      channel.L = 20;
      channel.R = 18;
      
  elseif strcmp(deviceName, 'RX6')
      channel.L = 1;
      channel.R = 2;
      
  else
      errorBeep('I don''t know the output channel numbers for this device\n');
  end
  
  device.SetTagVal('LeftChannel', channel.L)
  device.SetTagVal('RightChannel', channel.R)
  
end