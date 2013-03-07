classdef tdtStimDevice < handle
  properties
   deviceName = '';
   deviceHandle = [];
   sampleRate = -1;
   nChannels = -1;
  end

  methods

    function obj = tdtStimDevice(deviceInfo)
      obj.deviceName = deviceInfo.deviceName;
      obj.nChannels = deviceInfo.nChannels;
      obj.deviceHandle = tdtStimDevice();

      if nChannels==1
	    [obj.deviceHandle, obj.sampleRate] = deviceInit(device, deviceName, ...
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

  end
end