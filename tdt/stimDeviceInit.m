function [device, sampleRate] = ...
  stimDeviceInit(device, deviceName, requestedSampleRate)
% [device, sampleRate] = ...
%   stimDeviceInit(device, deviceName, requestedSampleRate)
% 
% Initialise TDT stimulus device
% 
% device: Existing handle to the device, or [] if you don't have one
% deviceName: e.g. 'RX6'
% requestedSampleRateHz: desired sample rate, e.g. 48828.125

[device, sampleRate] = deviceInit(device, deviceName, ...
  'tdt/stereoplay.rcx', 'StereoPlayVer', 3, requestedSampleRate);
