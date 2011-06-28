function [device, sampleRate] = dataDeviceInit(device, deviceName, requestedSampleRate, channelMapping)

[device, sampleRate] = deviceInit(device, deviceName, ['tdt/' deviceName '-nogain.rcx'], [deviceName 'GainVer'], 3, requestedSampleRate);
   

% NB! This mapping has to be uploaded to TDT as 32-bit integers
device.WriteTagVEX('ChanMap',0,'I32',channelMapping);