function device = stimDeviceInit(device, deviceName, requestedSampleRate)

device = deviceInit(device, deviceName, 'tdt/stereoplay.rcx', 'StereoPlayVer', 2, requestedSampleRate);
