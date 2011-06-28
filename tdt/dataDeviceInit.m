function [device, sampleRate] = dataDeviceInit(device, deviceName, requestedSampleRate, channelMapping)

[device, sampleRate] = deviceInit(device, deviceName, ['tdt/' deviceName '-gain.rcx'], [deviceName 'GainVer'], 2, requestedSampleRate);
   
for chan = 1:length(channelMapping)
  device.SetTagVal(['ec' num2str(chan) '_Chan'], channelMapping(chan));
end
