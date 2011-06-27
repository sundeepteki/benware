function device = stimDeviceInit(device, deviceName, requestedSampleRate)

device = deviceInit(device, deviceName, 'stereoplay.rcx', 'StereoPlayVer', 1, requestedSampleRate);
