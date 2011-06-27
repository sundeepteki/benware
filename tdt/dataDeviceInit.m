function device = dataDeviceInit(device, deviceName, requestedSampleRate, channelMapping)

device = deviceInit(device, deviceName, ['tdt/' deviceName '-gain.rcx'], [deviceName 'GainVer'], 1, requestedSampleRate);
   
for chan = 1:length(channelMapping)
  device.SetTagVal(['ec' num2str(chan) '_Chan'], channelMapping(chan));
end
