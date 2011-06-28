function [device, sampleRate] = stimDeviceInit(device, deviceName, requestedSampleRate)

[device, sampleRate] = deviceInit(device, deviceName, 'tdt/stereoplay.rcx', 'StereoPlayVer', 3, requestedSampleRate);
